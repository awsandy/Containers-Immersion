rc=$(aws ecr describe-repositories | jq .repositories[].repositoryName | wc -l)
if [[ $rc -eq 2 ]]; then
    echo "PASSED: found 2 images in ECR repo"
else
    echo "ERROR: found $rc images in ECR repo - expected 2"
fi
# image check
aws ecr describe-repositories | jq .repositories[].repositoryName | grep containersid-mono > /dev/null
if [[ $? -ne 0 ]]; then
    echo "ERROR: Can't find mono image in ECR"
else
    echo "PASSED: mono image in ECR "  
fi
aws ecr describe-repositories | jq .repositories[].repositoryName | grep containersid-like  > /dev/null
if [[ $? -ne 0 ]]; then
    echo "ERROR: Can't find like image in ECR"
else
    echo "PASSED: like image in ECR "  
fi
