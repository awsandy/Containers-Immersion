cd ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service
grep '${' monolith-app.yaml
if [[ $? -eq 0 ]];then
    echo "ERROR: check env vars sub in ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service/monolith-app.yaml"
else
    echo "PASSED: check env vars sub in ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service/monolith-app.yaml"
fi
grep ':latest' monolith-app.yaml
if [[ $? -ne 0 ]];then
    echo "ERROR: latest tag not found in ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service/monolith-app.yaml"
else
    echo "PASSED: latest tag found in ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service/monolith-app.yaml"
fi

echo "Repo check"
~/environment/Containers-Immersion/check-lab1.sh
rn=$(aws ecr describe-repositories | jq .repositories[].repositoryName | grep containersid-mono | tr -d '"')
aws ecr describe-images --repository-name $rn | grep latest > /dev/null
if [[ $? -ne 0 ]];then
    echo "ERROR: Can't find mono image latest tag in ECR"
else
    echo "PASSED: mono image latest tag found in ECR " 
fi
cd ~/environment/Containers-Immersion 