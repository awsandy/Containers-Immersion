. ~/.bash_profile
cd ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service
BUCKET_NAME="$(jq < ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/cfn-output.json -r '.SiteBucket')"
aws s3 cp index.html s3://${BUCKET_NAME}/
echo "hit http://${BUCKET_NAME}.s3-website.${AWS_REGION}.amazonaws.com/"
curl -s http://${BUCKET_NAME}.s3-website.${AWS_REGION}.amazonaws.com/ | grep mysfits > /dev/null   
if [[ $? -eq 0 ]];then
echo "All ok"
fi