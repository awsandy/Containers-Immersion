grep '${' ~/environment/mythicaleks.yaml
if [[ $? -eq 1 ]];then
    echo "ERROR: check env vars sub in ~/environment/mythicaleks.yaml"
fi
nc=$(kubectl get nodes)
if [[ $nc -lt 3 ]];then 
    echo "ERROR: expected 3x EKS nodes got $nc"
fi
pc=$(kubectl get pods -n kube-system | wc -l)
if [[ $pc -lt 8 ]];then 
    echo "ERROR: expected 8x running pods in kube-system got $pc"
fi
