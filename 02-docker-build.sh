cd ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service
MONO_ECR_REPOSITORY_URI=$(aws ecr describe-repositories | jq -r .repositories[].repositoryUri | grep mono)
docker build -t monolith-service:nolike .
docker tag monolith-service:nolike $MONO_ECR_REPOSITORY_URI:nolike
docker push $MONO_ECR_REPOSITORY_URI:nolike
#
cd ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/like-service
LIKE_ECR_REPOSITORY_URI=$(aws ecr describe-repositories | jq -r .repositories[].repositoryUri | grep like)
docker build -t like-service .
docker tag like-service:latest $LIKE_ECR_REPOSITORY_URI:latest
docker push $LIKE_ECR_REPOSITORY_URI:latest
