reg=$(aws configure get region)
n=${#reg}
if [[ $n -lt 9 ]]; then
    echo "ERROR: region set incorrectly $reg"
else
    echo "PASSED: configured region $reg"
fi
###
aws ec2 describe-iam-instance-profile-associations --query IamInstanceProfileAssociations --output text | grep containersid-MythicalProfile > /dev/null
if [[ $? -ne 0 ]]; then
    echo "ERROR: instance profile incorrect"
else
    echo "PASSED: instance profile set correctly"
fi
###
echo "checking base environment vars"
echo $BUCKET_NAME | grep containersid-mythicalbucket > /dev/null
if [[ $? -ne 0 ]]; then
    echo "ERROR: BUCKET_NAME not set / incorrect = $BUCKET_NAME"
else
    echo "PASSED: BUCKET_NAME = $BUCKET_NAME"
fi
echo $TABLE_NAME | grep containersid  > /dev/null
if [[ $? -ne 0 ]]; then
    echo "ERROR: TABLE_NAME not set / incorrect = $TABLE_NAME"
else
    echo "PASSED: TABLE_NAME = $TABLE_NAME"
fi
echo $API_ENDPOINT | grep containersid  > /dev/null
if [[ $? -ne 0 ]]; then
    echo "ERROR: API_ENDPOINT not set / incorrect = $API_ENDPOINT"
else
    echo "PASSED: API_ENDPOINT = $API_ENDPOINT"
fi
echo $MONO_ECR_REPOSITORY_URI | grep containersid  > /dev/null
if [[ $? -ne 0 ]]; then
    echo "ERROR: MONO_ECR_REPOSITORY_URI not set / incorrect = $MONO_ECR_REPOSITORY_URI"
else
    echo "PASSED: MONO_ECR_REPOSITORY_URI = $MONO_ECR_REPOSITORY_URI"
fi
echo "check instance association"

