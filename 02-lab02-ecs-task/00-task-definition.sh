export TF_VAR_lgn=$(aws logs describe-log-groups --query logGroups[].logGroupName | jq -r .[])
export TF_VAR_etr=$(aws iam list-roles | jq -r '.Roles[] | select(.RoleName | contains("ECSTaskRole")).Arn')
export TF_VAR_esr=$(aws iam list-roles | jq -r '.Roles[] | select(.RoleName | contains("EcsServiceRole")).Arn')
export TF_VAR_lb=$(aws elbv2 describe-load-balancers --query LoadBalancers[].DNSName | jq -r .[])
export TF_VAR_tn=$(aws dynamodb list-tables | jq -r '. | select(.TableNames[] | contains("Table-mod-")).TableNames' | jq -r .[0])
export TF_VAR_cn=$(aws ecs list-clusters | jq -r '. | select(.clusterArns[] | contains("Cluster-mod-")).clusterArns' | jq -r .[0] | rev | cut -f1 -d'/' | rev)
export TF_VAR_sn=$(aws ecs list-services --cluster $TF_VAR_cn | jq -r '. | select(.serviceArns[] | contains("MythicalMonolithService")).serviceArns' | jq -r .[0] | rev | cut -f1 -d'/' | rev)
export TF_VAR_ruri=$(aws ecr describe-repositories | jq -r .repositories[].repositoryUri | grep mono)
export TF_VAR_muid=$(echo TF_VAR_lgn | cut -f2 -d'-')

echo $TF_VAR_lgn
echo $TF_VAR_etr
echo $TF_VAR_esr
echo $TF_VAR_lb
echo $TF_VAR_tn
echo $TF_VAR_ruri
echo $TF_VAR_cn
echo $TF_VAR_sn
echo $TF_VAR_muid

cat << EOF > mono-container.json
[
      {
        command               = []
        cpu                   = 0
        dnsSearchDomains      = []
        dnsServers            = []
        dockerLabels          = {}
        dockerSecurityOptions = []
        entryPoint            = []
        environment = [
          {
            name  = "DDB_TABLE_NAME"
            value = ${TF_VAR_tn}
          },
          {
            name  = "UPSTREAM_URL"
            value = ${TF_VAR_lb}
          },
        ]
        environmentFiles = []
        essential        = true
        extraHosts       = []
        image            = ${TF_VAR_lb}:latest
        links            = []
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = ${TF_VAR_lgn}
            awslogs-region        = data.aws_region.current.name
            awslogs-stream-prefix = "awslogs-mythicalmysfits-service"
          }
          secretOptions = []
        }
        mountPoints = []
        name        = "monolith-service"
        portMappings = [
          {
            containerPort = 80
            hostPort      = 80
            protocol      = "tcp"
          },
        ]
        secrets        = []
        systemControls = []
        ulimits        = []
        volumesFrom    = []
      },
]
EOF

aws ecs register-task-definition \
--familly Monolith-Definition-mod-$TF_VAR_muid \ 
--network-mode awsvpc \
--task-role-arn $TF_VAR_etr \
--execution-role-arn $TF_VAR_esr \
--requires-compatibilities FARGATE \
--cpu 256 \
--memeory 512 \ 
--container-definitions file://mono-container.json