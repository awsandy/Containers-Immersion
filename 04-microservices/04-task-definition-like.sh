export TF_VAR_lgn=$(aws logs describe-log-groups --query logGroups[].logGroupName | jq -r .[])
export TF_VAR_etr=$(aws iam list-roles | jq -r '.Roles[] | select(.RoleName | contains("ECSTaskRole")).Arn')
export TF_VAR_esr=$(aws iam list-roles | jq -r '.Roles[] | select(.RoleName | contains("EcsServiceRole")).Arn')
export TF_VAR_lb=$(aws elbv2 describe-load-balancers --query LoadBalancers[].DNSName | jq -r .[])
export TF_VAR_tn=$(aws dynamodb list-tables | jq -r '. | select(.TableNames[] | contains("Table-mod-")).TableNames' | jq -r .[0])
export TF_VAR_cn=$(aws ecs list-clusters | jq -r '. | select(.clusterArns[] | contains("Cluster-mod-")).clusterArns' | jq -r .[0] | rev | cut -f1 -d'/' | rev)
export TF_VAR_sn=$(aws ecs list-services --cluster $TF_VAR_cn | jq -r '. | select(.serviceArns[] | contains("MythicalMonolithService")).serviceArns' | jq -r .[0] | rev | cut -f1 -d'/' | rev)
export TF_VAR_ruri=$(aws ecr describe-repositories | jq -r .repositories[].repositoryUri | grep mono)
export TF_VAR_muid=$(echo $TF_VAR_lgn | cut -f2 -d'-')
export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
export TF_VAR_luri=$(aws ecr describe-repositories | jq -r .repositories[].repositoryUri | grep like)


echo $TF_VAR_lgn
echo $TF_VAR_etr
echo $TF_VAR_esr
echo $TF_VAR_lb
echo $TF_VAR_tn
echo $TF_VAR_ruri
echo $TF_VAR_cn
echo $TF_VAR_sn
echo muid=$TF_VAR_muid


cat << EOF > like-container.json
[
      {
        "environment": [
          {
            "name": "MONOLITH_URL",
            "value": "${TF_VAR_lb}"
          }
        ],
        "essential":  true,
        "image": "${TF_VAR_luri}:latest",
       
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${TF_VAR_lgn}",
            "awslogs-region": "${AWS_REGION}",
            "awslogs-stream-prefix": "like-mythicalmysfits-service"
          }
        },

        "name": "mysfits-like",
        "portMappings": [
          {
            "containerPort": 80,
            "hostPort": 80,
            "protocol": "tcp"
          }
        ]
      }
]
EOF


aws ecs register-task-definition --family Like-Definition-mod-${TF_VAR_muid} --network-mode awsvpc \
--execution-role-arn ${TF_VAR_esr} \
--requires-compatibilities FARGATE \
--cpu 256 \
--memory 512 --container-definitions file://like-container.json
