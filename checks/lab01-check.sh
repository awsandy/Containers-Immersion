rc=$(aws ecr describe-repositories | jq .repositories[].repositoryName | wc -l)
if [[ $rc -eq 2 ]]; then
    echo "PASSED: found 2 images in ECR repo"
else
    echo "ERROR: found $rc images in ECR repo - expected 2"
fi
