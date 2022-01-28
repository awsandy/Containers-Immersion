ALB=$(kubectl get ing mythical-mysfits-eks -o json | jq -r '.status.loadBalancer.ingress[0].hostname' | grep -v Ingress)
echo $ALB
echo "copying /home/ec2-user/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/web/index.html"
cp /home/ec2-user/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/web/index.html index.html.orig 
echo "edit index.html"
grep REPLACE_ME_API_ENDPOINT index.html.orig
comm=$(printf "sed 's/REPLACE_ME_API_ENDPOINT/http:\/\/%s/' index.html.orig > index.html" $ALB)
echo $comm
eval $comm
grep mysfitsApiEndpoint index.html | grep '.com'
aws s3 cp index.html s3://${BUCKET_NAME}/ --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
echo "edit  likeservice-app.yaml - update ALB name"
