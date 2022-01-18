kubectl get ing mythical-mysfits-eks -o json | jq -r '.status.loadBalancer.ingress[0].hostname'
aws s3 cp web/index.html s3://${BUCKET_NAME}/ --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
echo "edit  likeservice-app.yaml "