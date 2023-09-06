export ELB=$(kubectl get service mythical-mysfits-eks -o json | jq -r '.status.loadBalancer.ingress[].hostname')
curl -s -m3 -v $ELB > /dev/null
while [[ $? -ne 0 ]];do
    echo "Waiting for ELB - sleeping 15s ....."
    sleep 15
    curl -s -m3 -v $ELB > /dev/null
done
echo "elb ok"
