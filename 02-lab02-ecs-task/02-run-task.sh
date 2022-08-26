export TF_VAR_cn=$(aws ecs list-clusters | jq -r '. | select(.clusterArns[] | contains("Cluster-mod-")).clusterArns' | jq -r .[0] | rev | cut -f1 -d'/' | rev)
tdarn = $(aws ecs list-task-definitions --query taskDefinitionArns | jq -r .[] | grep Monolith-Definition-mod- | tail -1)
vpcid=$(aws ec2 describe-vpcs --filters "Name=is-default,Values=false" --query Vpcs[].VpcId | jq -r .[])
sub1=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpcid" | jq '.Subnets[] |  select(.MapPublicIpOnLaunch==true)' | jq -r .SubnetId | head -1)
sg1=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$vpcid" | jq '.SecurityGroups[] |  select(.Description=="Access to the load balancer")' | jq -r .GroupId | head -1)
echo $sub1
echo $sg1
aws ecs run-task --cluster $TF_VAR_cn \
    --task-definition $tdarn \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[$sub1],securityGroups=[$sg1],assignPublicIp=ENABLED}"