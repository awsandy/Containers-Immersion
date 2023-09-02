ALB=$(kubectl get ing mythical-mysfits-eks -o json | jq -r '.status.loadBalancer.ingress[0].hostname' | grep -v Ingress)
echo $ALB | grep elb > /dev/null
if [[ $? -ne 0 ]];then
    echo "ALB not ready exiting"
    exit
fi
echo "copying /home/ec2-user/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/web/index.html"
cp /home/ec2-user/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/web/index.html index.html.orig 
echo "edit index.html"
grep REPLACE_ME_API_ENDPOINT index.html.orig
comm=$(printf "sed 's/REPLACE_ME_API_ENDPOINT/http:\/\/%s/' index.html.orig > index.html" $ALB)
echo $comm
eval $comm
(grep mysfitsApiEndpoint index.html | grep 'mythical') > /dev/null
if [[ $? -ne 0 ]];then
    echo "ERROR: Failed to find mythical in index.html"
    exit
fi

BUCKET_NAME="$(jq < ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/cfn-output.json -r '.SiteBucket')"
aws s3 cp index.html s3://${BUCKET_NAME}/
if [[ $? -ne 0 ]];then
    echo "ERROR: Failed to copy to bucket $BUCKET_NAME"
    exit
fi
#cp likeservice-app.yaml likeservice-app.yaml.orig
#s1=$(grep value likeservice-app.yaml.orig | cut -f2 -d':' | tr -d ' ')
#comm=$(printf "sed 's/%s/%s/' likeservice-app.yaml.orig > likeservice-app.yaml" $s1 $ALB)
#echo $comm
grep $ALB ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/monolith-service/likeservice-app.yaml
if [[ $? -eq 0 ]];then
    echo "ALB sub ok"
else
    echo "ALB substitution $ALB may have failed in likeservice-app.yaml - exit"
    exit
fi
hc=0
while [[ $hc -lt 6 ]];do
sleep 10
hc=0
    for i in `aws elbv2 describe-target-groups --query TargetGroups[].TargetGroupArn | jq -r .[] | grep k8s`;do
        hc1=$(aws elbv2 describe-target-health --target-group-arn $i --query TargetHealthDescriptions[].TargetHealth.State | grep healthy | wc -l)
        hc=`expr $hc + $hc1`   
    done

echo "found $hc healthy" 
done
echo "targets healthy"
