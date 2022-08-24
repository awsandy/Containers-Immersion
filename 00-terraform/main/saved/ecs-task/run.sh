export TF_VAR_lgn=$(aws logs describe-log-groups --query logGroups[].logGroupName | jq -r .[])
export TF_VAR_etr=$(aws iam list-roles | jq -r '.Roles[] | select(.RoleName | contains("ECSTaskRole")).Arn')
export TF_VAR_esr=$(aws iam list-roles | jq -r '.Roles[] | select(.RoleName | contains("EcsServiceRole")).Arn')
export TF_VAR_lb=$(aws elbv2 describe-load-balancers --query LoadBalancers[].DNSName | jq -r .[])
export TF_VAR_tn=$(aws dynamodb list-tables | jq -r '. | select(.TableNames[] | contains("Table-mod-")).TableNames' | jq -r .[0])
export TF_VAR_cn=$(aws ecs list-clusters | jq -r '. | select(.clusterArns[] | contains("Cluster-mod-")).clusterArns' | jq -r .[0] | rev | cut -f1 -d'/' | rev)
export TF_VAR_sn=$(aws ecs list-services --cluster $TF_VAR_cn | jq -r '. | select(.serviceArns[] | contains("MythicalMonolithService")).serviceArns' | jq -r .[0] | rev | cut -f1 -d'/' | rev)

export TF_VAR_ruri=$(aws ecr describe-repositories | jq -r .repositories[].repositoryUri | grep mono)
echo $TF_VAR_lgn
echo $TF_VAR_etr
echo $TF_VAR_esr
echo $TF_VAR_lb
echo $TF_VAR_tn
echo $TF_VAR_ruri
echo $TF_VAR_cn
echo $TF_VAR_sn
terraform validate
terraform refresh
terraform plan -out tfplan