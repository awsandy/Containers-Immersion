
pc=$(kubectl get pods -n kube-system | grep Running | grep aws-load-balancer-controller | wc -l)
if [[ $pc -lt 2 ]];then 
    echo "ERROR: expected 2x aws-load-balancer-controller running pods in kube-system got $pc"
else
    echo "PASSED: 2x running aws-load-balancer-controller pods in kube-system got $pc"
fi
