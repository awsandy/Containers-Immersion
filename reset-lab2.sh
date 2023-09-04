echo "stop any ECS tasks"
tsks=$(aws ecs list-tasks --cluster Cluster-containersid --query taskArns | jq -r .[] | rev | cut -f1 -d'/' | rev)
for i in $tsks; do
    aws ecs stop-task --task $i --cluster Cluster-containersid --output text
done
echo "delete ECS task definitions - except Monolith-Definition-containersid:1 "
tds=$(aws ecs list-task-definitions | jq -r .taskDefinitionArns[] | rev | cut -f1 -d'/' | rev)
for i in $tds; do
    if [[ $i != *"Monolith-Definition-containersid:1" ]]; then
        aws ecs deregister-task-definition --task-definition $i --output text
    fi
done
