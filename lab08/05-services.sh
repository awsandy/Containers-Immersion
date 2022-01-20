kubectl get ing mythical-mysfits-eks -o json | jq -r '.status.loadBalancer.ingress[0].hostname'
echo "copying /home/ec2-user/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/web/ndex.html"
cp /home/ec2-user/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/web/index.html .
echo "edit index.html"
aws s3 cp index.html s3://${BUCKET_NAME}/ --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
echo "edit  likeservice-app.yaml - update ALB name"