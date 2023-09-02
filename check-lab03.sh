export TF_VAR_cn=$(aws ecs list-clusters | jq -r '. | select(.clusterArns[] | contains("containersid")).clusterArns' | jq -r .[0] | rev | cut -f1 -d'/' | rev)
export TF_VAR_lgn=$(aws logs describe-log-groups --query logGroups[].logGroupName | jq -r .[])
export TF_VAR_muid=$(echo $TF_VAR_lgn | cut -f3 -d'-')
export TF_VAR_lb=$(aws elbv2 describe-load-balancers --query LoadBalancers[].DNSName | jq -r .[])
echo $TF_VAR_lb
#aws ecs list-tasks --cluster $TF_VAR_cn --family Monolith-Definition-mod-${TF_VAR_muid}
echo "ALB can take 90s ..."
curl -s $TF_VAR_lb/mysfits | grep haetae > /dev/null
while [[ $? -ne 0 ]]; do
echo "not ready sleep 15s .."
sleep 15
curl -s $TF_VAR_lb/mysfits | grep haetae > /dev/null
done
echo "success"
curl $TF_VAR_lb/mysfits
cd ~/environment/Containers-Immersion 