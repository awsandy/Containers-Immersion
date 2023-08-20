# check task definition refers to mono
rc=$(aws ecs list-task-definitions --query taskDefinitionArns --output text | grep containersid | grep -i mono | wc -l)
echo $rc
if [[ $rc -lt 1 ]]; then
    echo "ERROR: no task definition for mono"  
else
    echo "PASSED: found $rc task definitions for Mono"
fi
# image check
aws ecs list-task-definitions --query taskDefinitionArns --output text | grep containersid | grep -i mono | grep ':2' >/dev/null
if [[ $? -ne 0 ]]; then
    echo "ERROR: expected second :2 task definition"
fi
td=$(aws ecs list-task-definitions --query taskDefinitionArns | jq .[] |  aws ecs list-task-definitions --query taskDefinitionArns | jq -r '.[]' | grep ':2')
aws ecs describe-task-definition --task-definition $td --query taskDefinition.containerDefinitions | grep image | grep containersid-mono > /dev/null
if [[ $? -ne 0 ]]; then
    echo "ERROR: no containersid-mono ECR image in modified task definition"
fi
