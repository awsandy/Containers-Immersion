echo "check edits"
grep 'app.route("/mysfits/<mysfit_id>/fulfill-like' ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service/service/mythicalMysfitsService.py | grep '#'
if [[ $? -eq 0 ]]; then
    echo "ERROR: app.route fullfill-like still commented in mythicalMysfitsService.py"
else
    echo "PASSED: app.route fullfill-like uncommented in mythicalMysfitsService.py"
fi
## check monolyth now has nolike tag - as like now implemented elsewhere
aws ecr describe-repositories | jq .repositories[].repositoryName | grep containersid-mono > /dev/null
if [[ $? -ne 0 ]]; then
    echo "ERROR: Can't find mono image in ECR"
else
    echo "PASSED: mono image in ECR "  
fi
rn=$(aws ecr describe-repositories | jq -r .repositories[].repositoryName | grep containersid-mono) > /dev/null
aws ecr describe-images --repository-name $rn | grep nolike 
if [[ $? -ne 0 ]];then
    echo "ERROR: Can't find mono image nolike tag in ECR"
else
    echo "PASSED: mono image nolike tag found in ECR " 
fi
