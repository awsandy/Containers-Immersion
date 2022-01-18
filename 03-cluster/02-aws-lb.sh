curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
  #create the policy
aws iam create-policy \
      --policy-name AWSLoadBalancerControllerIAMPolicy \
      --policy-document file://iam-policy.json

echo"get the policy ARN"
export PolicyARN=$(aws iam list-policies --query 'Policies[?PolicyName==`AWSLoadBalancerControllerIAMPolicy`].Arn' --output text)
echo $PolicyARN
eksctl create iamserviceaccount \
  --cluster=mythicaleks-eksctl \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=$PolicyARN \
  --override-existing-serviceaccounts \
  --approve

kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
echo "helm install"
helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=mythicaleks-eksctl \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
sleep 5
kubectl logs -n kube-system deployments/aws-load-balancer-controller
sleep 5
kubectl -n kube-system get deployments

