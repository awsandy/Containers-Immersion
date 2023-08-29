grep '${' ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service/monolith-app.yaml
if [[ $? -eq 0 ]];then
    echo "ERROR: check env vars sub in ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service/monolith-app.yaml"
else
    echo "PASSED: check env vars sub in ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service/monolith-app.yaml"
fi
echo "Repo check"
./lab01-check.sh
mr=$(aws ecr describe-repositories | jq .repositories[].repositoryName | grep containersid-mono | tr -d '"')
