export TF_VAR_cn=$(aws ecs list-clusters | jq -r '. | select(.clusterArns[] | contains("containersid")).clusterArns' | jq -r .[0] | rev | cut -f1 -d'/' | rev)
export TF_VAR_sn=$(aws ecs list-services --cluster $TF_VAR_cn | jq -r '. | select(.serviceArns[] | contains("MythicalMonolithService")).serviceArns' | jq -r .[0] | rev | cut -f1 -d'/' | rev)
export TF_VAR_ruri=$(aws ecr describe-repositories | jq -r .repositories[].repositoryUri | grep mono)
export TF_VAR_lgn=$(aws logs describe-log-groups --query logGroups[].logGroupName | jq -r .[])
export TF_VAR_muid=$(echo $TF_VAR_lgn | cut -f3 -d'-')
tdarn=$(aws ecs list-task-definitions --query taskDefinitionArns | jq -r .[] | grep Monolith-Definition-mod- | tail -1)
export TF_VAR_lb=$(aws elbv2 describe-load-balancers --query LoadBalancers[].DNSName | jq -r .[])
ldarn=$(aws ecs list-task-definitions --query taskDefinitionArns | jq -r .[] | grep Like-Definition-mod- | tail -1)
vpcid=$(aws ec2 describe-vpcs --filters "Name=is-default,Values=false" --query Vpcs[].VpcId | jq -r .[])
sub1=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpcid" | jq '.Subnets[] |  select(.MapPublicIpOnLaunch==true)' | jq -r .SubnetId | head -1)
sg1=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$vpcid" | jq '.SecurityGroups[] |  select(.Description=="Access to the load balancer")' | jq -r .GroupId | head -1)

# get lbname

# create new target group
 
aws elbv2 create-target-group \
              --name mysfits-like-target \
              --protocol HTTP \
              --port 80 \
              --target-type ip \
              --vpc-id $vpcid 

lbarn=$(aws elbv2 describe-load-balancers --query LoadBalancers[].LoadBalancerArn | jq -r .[])
tgarn=$(aws elbv2 describe-target-groups --names mysfits-like-target --query TargetGroups[].TargetGroupArn | jq -r .[])
lnarn=$(aws elbv2 describe-listeners --load-balancer-arn $lbarn --query Listeners[].ListenerArn | jq -r .[])
cat << EOF > conditions-pattern.json
[
    {
        "Field": "path-pattern",
        "PathPatternConfig": {
            "Values": ["/mysfits/*/like"]
        }
    }
]
EOF

# listener RULES tie ALB to a target group
# add a rule for new target group path /mysfit/*/like

aws elbv2 create-rule \
              --listener-arn ${lnarn} \
              --priority 1 \
              --conditions file://conditions-pattern.json \
              --actions Type=forward,TargetGroupArn=${tgarn}


# create like service - inject IP's form mysfits-like into target group

cat << EOF > service-elb.json
{
    "loadBalancers": [
        {
            "containerName": "mysfits-like",
            "containerPort": 80,
            "targetGroupArn": "${tgarn}"
        }
    ]
}
EOF



# ECS Service injects container IP's into the defined ELB target group
# container name is in json - and will match the one in task definition 

aws ecs  create-service --cluster $TF_VAR_cn --service-name mysfits-like-service \
--task-definition $ldarn \
--desired-count 1 \
--launch-type FARGATE \
--platform-version LATEST \
--network-configuration "awsvpcConfiguration={subnets=[$sub1],securityGroups=[$sg1],assignPublicIp=ENABLED}" \
--cli-input-json file://service-elb.json
