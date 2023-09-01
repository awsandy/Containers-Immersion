. ~/.bash_profile
echo "bucket-name=${BUCKET_NAME}"
aws s3 ls ${BUCKET_NAME}
aws s3 cp index.html s3://${BUCKET_NAME}/ --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
echo "hit http://${BUCKET_NAME}.s3-website.${AWS_REGION}.amazonaws.com/"
curl -s http://${BUCKET_NAME}.s3-website.${AWS_REGION}.amazonaws.com/ | grep mysfits > /dev/null   
if [[ $? -eq 0 ]];then
echo "All ok"
fi