# check task definition refers to mono
rc=$(aws ecs list-task-definitions --query taskDefinitionArns --output text | grep containersid | grep -i mono | wc -l)
if [[ $rc -lt 1 ]]; then
    echo "ERROR: no task definition for mono"  
else
    echo "PASSED: found $rc task definitions for Mono"
fi
# image check
tdc=$(aws ecs list-task-definitions --query taskDefinitionArns --output text | grep containersid | grep -i mono | wc -l 
if [[ $tdc -lt 2 ]]; then
    echo "ERROR: expected second task definition"
else
    echo "PASSED: found >1 task definition for Mono"
fi
td=$(aws ecs list-task-definitions --query taskDefinitionArns | jq .[] |  aws ecs list-task-definitions --query taskDefinitionArns | jq -r '.[]' | grep ':2')
aws ecs describe-task-definition --task-definition $td --query taskDefinition.containerDefinitions | grep image | grep containersid-mono > /dev/null
if [[ $? -ne 0 ]]; then
    echo "ERROR: no containersid-mono ECR image in modified task definition"
else
    echo "PASSED: found containersid-mono ECR image in modified task definition"
fi
cd ~/environment/Containers-Immersion 