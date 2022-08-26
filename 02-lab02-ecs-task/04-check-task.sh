export TF_VAR_cn=$(aws ecs list-clusters | jq -r '. | select(.clusterArns[] | contains("Cluster-mod-")).clusterArns' | jq -r .[0] | rev | cut -f1 -d'/' | rev)
export TF_VAR_lgn=$(aws logs describe-log-groups --query logGroups[].logGroupName | jq -r .[])
export TF_VAR_muid=$(echo $TF_VAR_lgn | cut -f2 -d'-')
export TF_VAR_lb=$(aws elbv2 describe-load-balancers --query LoadBalancers[].DNSName | jq -r .[])
echo $TF_VAR_lb
aws ecs list-tasks --cluster $TF_VAR_cn --family Monolith-Definition-mod-${TF_VAR_muid}
