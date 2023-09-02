(docker images -q | xargs docker rmi || true) 2>/dev/null
if [[ $1 != "eks" ]]; then
    echo "scale ECS services to 0 and delete them"
    srvs=$(aws ecs list-services --cluster Cluster-containersid --query serviceArns | jq -r .[] | rev | cut -f1 -d'/' | rev)
    for i in $srvs; do
        aws ecs update-service --cluster Cluster-containersid --service $i --desired-count 0 --output text
        aws ecs delete-service --cluster Cluster-containersid --service $i --output text
    done
    echo "stop any ECS tasks"
    tsks=$(aws ecs list-tasks --cluster Cluster-containersid --query taskArns | jq -r .[] | rev | cut -f1 -d'/' | rev)
    for i in $tsks; do
        aws ecs stop-task --task $i --cluster Cluster-containersid
    done
    echo "delete ECS task definitions - except Monolith-Definition-containersid:1 "
    tds=$(aws ecs list-task-definitions | jq -r .taskDefinitionArns[] | rev | cut -f1 -d'/' | rev)
    for i in $tds; do
        if [[ $i != *"Monolith-Definition-containersid:1" ]]; then
            aws ecs deregister-task-definition --task-definition $i
        fi
    done
fi
echo "delete EKS manifestes etc.."
kubectl delete deployment mythical-mysfits-like
kubectl delete deployment mythical-mysfits-nolike
kubectl get ingress/mythical-mysfits-eks
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
    aws cloudformation delete-stack --stack-name eksctl-mythicaleks-eksctl
    echo "Waiting for stack set eksctl-mythicaleks-eksctl"
    aws cloudformation wait stack-delete-complete --stack-name eksctl-mythicaleks-eksctl
fi

# delete the stacks anyway
