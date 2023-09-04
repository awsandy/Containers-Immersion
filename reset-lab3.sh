export TF_VAR_cn=$(aws ecs list-clusters | jq -r '. | select(.clusterArns[] | contains("containersid")).clusterArns' | jq -r .[0] | rev | cut -f1 -d'/' | rev)
export TF_VAR_sn=$(aws ecs list-services --cluster $TF_VAR_cn | jq -r '. | select(.serviceArns[] | contains("MythicalMonolithService")).serviceArns' | jq -r .[0] | rev | cut -f1 -d'/' | rev)
export TF_VAR_ruri=$(aws ecr describe-repositories | jq -r .repositories[].repositoryUri | grep -i mono)
export TF_VAR_lgn=$(aws logs describe-log-groups --query logGroups[].logGroupName | jq -r .[])
export TF_VAR_muid=$(echo $TF_VAR_lgn | cut -f3 -d'-')
tdarn=$(aws ecs list-task-definitions --query taskDefinitionArns | jq -r .[] | grep Monolith | grep ':1' | tail -1)
export TF_VAR_lb=$(aws elbv2 describe-load-balancers --query LoadBalancers[].DNSName | jq -r .[])
echo "reset service"
aws ecs update-service --cluster $TF_VAR_cn --service $TF_VAR_sn --task-definition $tdarn --output text
if [[ $? -ne 0 ]]; then
    echo "failed to update service"
fi