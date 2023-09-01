grep '${' ~/environment/mythicaleks.yaml
if [[ $? -eq 0 ]];then
    echo "ERROR: check env vars sub in ~/environment/mythicaleks.yaml"
else
    echo "PASSED: check env vars sub in ~/environment/mythicaleks.yaml"
fi
reg=$(aws configure get region)
grep $reg ~/environment/mythicaleks.yaml
if [[ $? -ne 0 ]];then
    echo "ERROR: no region $reg in ~/environment/mythicaleks.yaml"
else
    echo "PASSED: region $reg in ~/environment/mythicaleks.yaml"
fi
nc=$(kubectl get nodes | grep Ready | wc -l )
if [[ $nc -lt 3 ]];then 
    echo "ERROR: expected 3x Ready EKS nodes got $nc"
else
    echo "PASSED: 3x Ready EKS nodes got $nc"
fi
pc=$(kubectl get pods -n kube-system | grep Running | wc -l)
if [[ $pc -lt 8 ]];then 
    echo "ERROR: expected 8x running pods in kube-system got $pc"
else
    echo "PASSED: 8x  running pods in kube-system got $pc"
fi
