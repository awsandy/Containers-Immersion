#kubectl delete deployment mythical-mysfits-eks 2> /dev/null
#kubectl delete service mythical-mysfits-eks 2> /dev/null
kubectl delete -f /home/ec2-user/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service/monolith-app.yaml
#eksctl delete iamserviceaccount \
#		--cluster=mythicaleks-eksctl \
#		--namespace=default \
#		--name=mythical-misfit
#export PolicyARNDynamoDB=$(aws iam list-policies --query 'Policies[?PolicyName==`MythicalMisfitDynamoDBTablePolicy`].Arn' --output text)
#aws iam delete-policy --policy-arn $PolicyARNDynamoDB

