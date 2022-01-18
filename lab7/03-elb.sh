ELB=$(kubectl get service mythical-mysfits-eks -o json | jq -r '.status.loadBalancer.ingress[].hostname')
curl -m3 -v $ELB
