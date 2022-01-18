BUCKET_NAME=$(jq < ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/cfn-output.json -r '.SiteBucket')
echo "bucket-name=${BUCKET_NAME}"
aws s3 ls ${BUCKET_NAME}
aws s3 cp index.html s3://${BUCKET_NAME}/ --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers full=emailaddress=user@example.com
aws s3 cp index.html s3://${BUCKET_NAME}/ --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
echo "hit http://${BUCKET_NAME}.s3-website.${AWS_REGION}.amazonaws.com/"