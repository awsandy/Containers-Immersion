TF_VAR_lgn=$(aws logs describe-log-groups --query logGroups[].logGroupName | jq -r .[])
TF_VAR_etr=$(aws iam list-roles | jq -r '.Roles[] | select(.RoleName | contains("ECSTaskRole")).RoleName')
TF_VAR_esr=$(aws iam list-roles | jq -r '.Roles[] | select(.RoleName | contains("ECSServiceRole")).RoleName')
TF_VAR_lb=$(aws elbv2 describe-load-balancers --query LoadBalancers[].DNSName | jq -r .[])
echo $TF_VAR_lgn
echo $TF_VAR_etr
echo $TF_VAR_esr
echo $TF_VAR_lb