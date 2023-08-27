

CloudWatchAgentServerPolicy to cloudwatch role

```bash
export namespace=amazon-cloudwatch
export service_account=cloudwatch-agent
account_id=$(aws sts get-caller-identity --query "Account" --output text)
#
kubectl annotate serviceaccount -n $namespace $service_account eks.amazonaws.com/role-arn=arn:aws:iam::$account_id:role/role-cloudwatch-agent
#
#
export service_account=fluent-bit
kubectl annotate serviceaccount -n $namespace $service_account eks.amazonaws.com/role-arn=arn:aws:iam::$account_id:role/role-fluent-bit

```