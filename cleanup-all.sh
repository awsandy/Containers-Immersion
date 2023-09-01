# scale and delete ECS services
srvs=$(aws ecs list-services --cluster Cluster-containersid --query serviceArns | jq -r .[] | rev | cut -f1 -d'/' | rev)
for i in $srvs;do
aws ecs update-service --cluster Cluster-containersid --service $i --desired-count 0 --output text
aws ecs delete-service --cluster Cluster-containersid --service $i --output text
done