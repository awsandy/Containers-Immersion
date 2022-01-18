cp Dockerfile ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service/
cd ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service/
docker build -t monolith-service .

MONO_ECR_REPOSITORY_URI=$(aws ecr describe-repositories | jq -r .repositories[].repositoryUri | grep mono)
docker tag monolith-service:latest $MONO_ECR_REPOSITORY_URI:latest
docker push $MONO_ECR_REPOSITORY_URI:latest