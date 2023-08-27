cat >serv-accounts.yaml <<EOF
# create amazon-cloudwatch namespace
apiVersion: v1
kind: Namespace
metadata:
  name: amazon-cloudwatch
  labels:
    name: amazon-cloudwatch
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: cloudwatch-agent
  namespace: amazon-cloudwatch
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: fluent-bit
  namespace: amazon-cloudwatch
EOF

kubectl apply -f serv-accounts.yaml



export AWS_REGION=$(aws configure get region)
export CLUSTER=mythicaleks-eksctl
export namespace=amazon-cloudwatch
export service_account=cloudwatch-agent
account_id=$(aws sts get-caller-identity --query "Account" --output text)
oidc_provider=$(aws eks describe-cluster --name $CLUSTER --region $AWS_REGION --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")
cat >trust-relationship.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::$account_id:oidc-provider/$oidc_provider"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "$oidc_provider:aud": "sts.amazonaws.com",
          "$oidc_provider:sub": "system:serviceaccount:$namespace:$service_account"
        }
      }
    }
  ]
}
EOF
# Do with Terraform
#
#aws iam create-role --role-name role-fluent-bit --assume-role-policy-document file://trust-relationship.json --description "EKS fluent bit role"
#aws iam create-role --role-name role-cloudwatch-agent --assume-role-policy-document file://trust-relationship.json --description "EKS cloudwatch role"
#aws iam attach-role-policy --role-name role-cloudwatch-agent --policy-arn=arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy
