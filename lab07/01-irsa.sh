cd /home/ec2-user/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service
export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
cat << EOF > iam-dynamodb-policy.json
{
"Version": "2012-10-17",
"Statement": [
	{
		"Effect": "Allow",
		"Action": [
			"dynamodb:*"
		],
		"Resource": "arn:aws:dynamodb:${AWS_REGION}:${ACCOUNT_ID}:table/${TABLE_NAME}"
	}
]}
EOF
echo "#create the policy"
aws iam create-policy \
				--policy-name MythicalMisfitDynamoDBTablePolicy \
				--policy-document file://iam-dynamodb-policy.json

#get the policy ARN
export PolicyARNDynamoDB=$(aws iam list-policies --query 'Policies[?PolicyName==`MythicalMisfitDynamoDBTablePolicy`].Arn' --output text)
echo $PolicyARNDynamoDB
echo "Create service account  ......"
eksctl create iamserviceaccount \
		--cluster=mythicaleks-eksctl \
		--namespace=default \
		--name=mythical-misfit \
		--attach-policy-arn=$PolicyARNDynamoDB \
		--override-existing-serviceaccounts \
		--approve --output text

