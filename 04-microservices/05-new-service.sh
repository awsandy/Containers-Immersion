export TF_VAR_cn=$(aws ecs list-clusters | jq -r '. | select(.clusterArns[] | contains("Cluster-mod-")).clusterArns' | jq -r .[0] | rev | cut -f1 -d'/' | rev)
export TF_VAR_sn=$(aws ecs list-services --cluster $TF_VAR_cn | jq -r '. | select(.serviceArns[] | contains("MythicalMonolithService")).serviceArns' | jq -r .[0] | rev | cut -f1 -d'/' | rev)
export TF_VAR_ruri=$(aws ecr describe-repositories | jq -r .repositories[].repositoryUri | grep mono)
export TF_VAR_cn=$(aws ecs list-clusters | jq -r '. | select(.clusterArns[] | contains("Cluster-mod-")).clusterArns' | jq -r .[0] | rev | cut -f1 -d'/' | rev)
export TF_VAR_lgn=$(aws logs describe-log-groups --query logGroups[].logGroupName | jq -r .[])
export TF_VAR_muid=$(echo $TF_VAR_lgn | cut -f2 -d'-')
tdarn=$(aws ecs list-task-definitions --query taskDefinitionArns | jq -r .[] | grep Monolith-Definition-mod- | tail -1)
export TF_VAR_lb=$(aws elbv2 describe-load-balancers --query LoadBalancers[].DNSName | jq -r .[])
ldarn=$(aws ecs list-task-definitions --query taskDefinitionArns | jq -r .[] | grep Monolith-Definition-mod- | tail -1)

vpcid=$(aws ec2 describe-vpcs --filters "Name=is-default,Values=false" --query Vpcs[].VpcId | jq -r .[])
sub1=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpcid" | jq '.Subnets[] |  select(.MapPublicIpOnLaunch==true)' | jq -r .SubnetId | head -1)
sg1=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$vpcid" | jq '.SecurityGroups[] |  select(.Description=="Access to the load balancer")' | jq -r .GroupId | head -1)


# get lbname

# create new target group

# aws elbv2 create-target-group  --name mysfits-like-target 
aws elbv2 create-target-group \
              --name mysfits-like-target \
              --protocol TCP \
              --port 80 \
              --target-type ip \
              --vpc-id $vpcid \

#adjust listener RULES ?
# listener RULES tie ALB to a target group
# add a rule for new target group path /mysfit/*/like
#



# create like service

# tgarn=$(aws elbv2)

cat << EOF > service-elb.json
{
    "loadBalancers": [
        {
            "containerName": "mysfits-like",
            "containerPort": 80
            "targetGroupArn:" ${TF_VAR_tgarn}
            }
        ],
}

EOF



# Service injects container IP's into the defined ELB target group 

aws ecs  create-service --cluster $TF_VAR_cn --service mysfits-like-service \
--task-definition $ldarn \
--desired-count 1 \
--launch-type FARGATE \
--platform-version LATEST \
--network-configuration "awsvpcConfiguration={subnets=[$sub1],securityGroups=[$sg1],assignPublicIp=ENABLED}" \
--cli-input-json file://service-elb.json


