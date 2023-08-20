# check task definition refers to mono
rc=$(aws ecs list-task-definitions --query taskDefinitionArns --output text | grep containersid | grep -i mono | wc -l)
if [[ $rc -lt 1 ]]; then
    echo "PASSED: found $rc task definitions for Mono"
else
    echo "ERROR: no task definition for mono"
fi
# image check
td=$(aws ecs list-task-definitions --query taskDefinitionArns --output text | grep containersid | grep -i mono)
aws ecs describe-task-definition --task-definition $td 