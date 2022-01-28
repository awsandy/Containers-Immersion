export ELB=$(kubectl get service mythical-mysfits-eks -o json | jq -r '.status.loadBalancer.ingress[].hostname')
curl -m3 -v $ELB
while [[ $? -ne 0 ]];do
    sleep 15
    curl -m3 -v $ELBs
done
echo "elb ok"
