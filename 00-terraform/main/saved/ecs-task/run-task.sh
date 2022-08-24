export TF_VAR_cn=$(aws ecs list-clusters | jq -r '. | select(.clusterArns[] | contains("Cluster-mod-")).clusterArns' | jq -r .[0] | rev | cut -f1 -d'/' | rev)

tdarn=$(terraform show -json | jq '.values.root_module.resources[] | select (.address=="aws_ecs_task_definition.task-definition_Monolith-Definition-mod-c24aacc7ec26455c_1").values.arn')

aws ecs run-task --cluster $TF_VAR_cn \
    --task-definition $tdarn \
    --launch-type FARGATE 
