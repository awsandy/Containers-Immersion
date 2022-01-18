cd /home/ec2-user/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/web
echo 'Take the ELB URL and search for "mysfitsApiEndpoint" in the index.html file and replace the ELB DNS name without any trailing "/".'
BUCKET_NAME=$(jq < ../cfn-output.json -r '.SiteBucket')
aws s3 ls ${BUCKET_NAME}
aws s3 cp index.html s3://${BUCKET_NAME}/ --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers full=emailaddress=user@example.com
aws s3 cp index.html s3://${BUCKET_NAME}/ --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
echo "hit http://<BUCKET_NAME>.s3-website.<AWS_REGION>.amazonaws.com/"