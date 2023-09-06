cd ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service
ELB=$(kubectl get service mythical-mysfits-eks -o json | jq -r '.status.loadBalancer.ingress[].hostname')
cp /home/ec2-user/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/web/index.html index.html.orig
grep REPLACE_ME_API_ENDPOINT index.html.orig
comm=$(printf "sed 's/REPLACE_ME_API_ENDPOINT/http:\/\/%s/' index.html.orig > index.html" $ELB)
echo $comm
eval $comm
grep mysfitsApiEndpoint index.html | grep '.com'
