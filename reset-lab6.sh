helm uninstall aws-load-balancer-controller -n kube-system
kubectl delete crds ingressclassparams.elbv2.k8s.aws 
kubectl delete crds targetgroupbindings.elbv2.k8s.aws
eksctl delete iamserviceaccount \
  --cluster=mythicaleks-eksctl \
  --namespace=kube-system \
  --name=aws-load-balancer-controller
export PolicyARN=$(aws iam list-policies --query 'Policies[?PolicyName==`AWSLoadBalancerControllerIAMPolicy`].Arn' --output text)
aws iam delete-policy --policy-arn $PolicyARN