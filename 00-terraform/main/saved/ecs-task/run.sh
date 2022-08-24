lgn=$(aws logs describe-log-groups --query logGroups[].logGroupName | jq -r .[])
echo $lgn
export TV_VAR_lgn=$(echo $lgn)