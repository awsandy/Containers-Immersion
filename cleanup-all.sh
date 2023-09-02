# scale and delete ECS services
srvs=$(aws ecs list-services --cluster Cluster-containersid --query serviceArns | jq -r .[] | rev | cut -f1 -d'/' | rev)
for i in $srvs;do
aws ecs update-service --cluster Cluster-containersid --service $i --desired-count 0 --output text
aws ecs delete-service --cluster Cluster-containersid --service $i --output text
done
tsks=$(aws ecs list-tasks --cluster Cluster-containersid --query taskArns | jq -r .[] | rev | cut -f1 -d'/' | rev)
for i in $tsks;do
aws ecs stop-task --task $i --cluster Cluster-containersid
done
tds=$(aws ecs list-task-definitions | jq -r .taskDefinitionArns[] | rev | cut -f1 -d'/' | rev)
for i in $tds;do
if [[ $i != *"Monolith-Definition-containersid:1" ]];then
aws ecs deregister-task-definition --task-definition $i
fi
done
echo "delete EKS nodegroup"
eksctl delete nodegroup --cluster mythicaleks-eksctl --name nodegroup || true
echo "Waiting for stack set eksctl-mythicaleks-eksctl-nodegroup-nodegroup"
aws cloudformation wait stack-delete-complete  --stack-name eksctl-mythicaleks-eksctl-nodegroup-nodegroup
echo "delete EKS cluster"
eksctl delete cluster --name mythicaleks-eksctl || true
echo "Waiting for stack set eksctl-mythicaleks-eksctl
aws cloudformation wait stack-delete-complete  --stack-name eksctl-mythicaleks-eksctl
(docker images -q | xargs docker rmi || true) 2> /dev/null