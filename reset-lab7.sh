kubectl delete deployment mythical-mysfits-eks 2> /dev/null
kubectl delete service mythical-mysfits-eks 2> /dev/null
eksctl delete iamserviceaccount \
		--cluster=mythicaleks-eksctl \
		--namespace=default \
		--name=mythical-misfit
export PolicyARNDynamoDB=$(aws iam list-policies --query 'Policies[?PolicyName==`MythicalMisfitDynamoDBTablePolicy`].Arn' --output text)
aws iam delete-policy --policy-arn $PolicyARNDynamoDB

