MONO_ECR_REPOSITORY_URI=$(aws ecr describe-repositories | jq -r .repositories[].repositoryUri | grep mono)
repo=$(echo $MONO_ECR_REPOSITORY_URI | cut -f1 -d'/')
echo $MONO_ECR_REPOSITORY_URI
echo $repo
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin $repo
docker rm $MONO_ECR_REPOSITORY_URI:latest