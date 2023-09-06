echo "delete EKS manifestes etc.."
kubectl delete deployment mythical-mysfits-like
kubectl delete deployment mythical-mysfits-nolike
kubectl get ingress/mythical-mysfits-eks
lbs=$(aws elbv2 describe-load-balancers --query LoadBalancers[].LoadBalancerArn | jq -r .[] | grep mythical)
for i in $lbs;do
aws elbv2 delete-load-balancer --load-balancer-arn $i
done
sgs=$(aws ec2 describe-security-groups --query SecurityGroups[] | jq -r '.[] | select(.GroupName | contains("mythical")).GroupId')
for i in $sgs;do
# get sg groupid
aws ec2 delete-security-group --group-id $i
done
echo "delete EKS addons"
eksctl delete iamserviceaccount \
    --cluster=mythicaleks-eksctl \
    --namespace=kube-system \
    --name=aws-load-balancer-controller
eksctl delete iamserviceaccount \
    --cluster=mythicaleks-eksctl \
    --namespace=default \
    --name=mythical-misfit
echo "delete EKS nodegroup"
eksctl delete nodegroup --cluster mythicaleks-eksctl --name nodegroup
if [[ $? -ne 0 ]]; then
    aws cloudformation delete-stack --stack-name eksctl-mythicaleks-eksctl-nodegroup-nodegroup
    echo "Waiting for stack set eksctl-mythicaleks-eksctl-nodegroup-nodegroup"
    aws cloudformation wait stack-delete-complete --stack-name eksctl-mythicaleks-eksctl-nodegroup-nodegroup
fi
echo "delete EKS cluster"
eksctl delete cluster --name mythicaleks-eksctl
if [[ $? -ne 0 ]]; then
    aws cloudformation delete-stack --stack-name eksctl-mythicaleks-eksctl-cluster
    echo "Waiting for stack set eksctl-mythicaleks-eksctl-cluster"
    aws cloudformation wait stack-delete-complete --stack-name eksctl-mythicaleks-eksctl-cluster
fi

# delete the stacks anyway