echo "check edits"
grep 'app.route("/mysfits/<mysfit_id>/fulfill-like' ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service/service/mythicalMysfitsService.py | grep '#'
if [[ $? -eq 0 ]]; then
    echo "ERROR: app.route fullfill-like still commented in mythicalMysfitsService.py"
else
    echo "PASSED: app.route fullfill-like uncommented in mythicalMysfitsService.py"
fi
grep 'def fulfillLikeMysfit(mysfit_id):' ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service/service/mythicalMysfitsService.py | grep '#'
if [[ $? -eq 0 ]]; then
    echo "ERROR: def fulfillLikeMysfit still commented in mythicalMysfitsService.py"
else
    echo "PASSED: def fulfillLikeMysfit uncommented in mythicalMysfitsService.py"
fi
## check monolyth now has nolike tag - as like now implemented elsewhere
aws ecr describe-repositories | jq .repositories[].repositoryName | grep containersid-mono > /dev/null
if [[ $? -ne 0 ]]; then
    echo "ERROR: Can't find mono repo in ECR"
else
    echo "PASSED: mono repo found in ECR "  
fi
aws ecr describe-repositories | jq .repositories[].repositoryName | grep containersid-like > /dev/null
if [[ $? -ne 0 ]]; then
    echo "ERROR: Can't find like repo in ECR"
else
    echo "PASSED: like repo found in ECR "  
fi
rn=$(aws ecr describe-repositories | jq -r .repositories[].repositoryName | grep containersid-mono) 
aws ecr describe-images --repository-name $rn | grep nolike > /dev/null
if [[ $? -ne 0 ]];then
    echo "ERROR: Can't find mono image nolike tag in ECRrepo $rn""
else
    echo "PASSED: mono image nolike tag found in ECR repo $rn" " 
fi
rn=$(aws ecr describe-repositories | jq -r .repositories[].repositoryName | grep containersid-like) 
aws ecr describe-images --repository-name $rn | grep like > /dev/null
if [[ $? -ne 0 ]];then
    echo "ERROR: Can't find like image in ECR repo $rn"
else
    echo "PASSED: like image found in ECR repo $rn " 
fi
cd ~/environment/Containers-Immersion 
