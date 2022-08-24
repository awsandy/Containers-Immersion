lgn=$(aws logs describe-log-groups --query logGroups[].logGroupName | jq -r .[])
echo $lgn
export TF_VAR_lgn=$(echo $lgn)