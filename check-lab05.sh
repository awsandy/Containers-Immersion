grep '${' ~/environment/mythicaleks.yaml 2>/dev/null
if [[ $? -eq 0 ]]; then
    grep '${' ~/environment/Containers-Immersion/lab05-eks-cluster/mythicaleks.yaml 2>/dev/null
    if [[ $? -ne 0 ]]; then
        echo "ERROR: check env vars sub in ~/environment/mythicaleks.yaml (or ~/environment/Containers-Immersion/lab05-eks-cluster/mythicaleks.yaml)"
    fi
else
    echo "PASSED: check env vars sub in ~/environment/mythicaleks.yaml (or ~/environment/Containers-Immersion/lab05-eks-cluster/mythicaleks.yaml)"
fi
reg=$(aws configure get region)
grep $reg ~/environment/mythicaleks.yaml 2> /dev/null
if [[ $? -ne 0 ]]; then
    grep $reg ~/environment/Containers-Immersion/lab05-eks-cluster/mythicaleks.yaml > /dev/null
    if [[ $? -ne 0 ]]; then
        echo "ERROR: no region $reg  in ~/environment/mythicaleks.yaml (or ~/environment/Containers-Immersion/lab05-eks-cluster/mythicaleks.yaml)"
    fi
else
    echo "PASSED: region $reg in ~/environment/mythicaleks.yaml (or ~/environment/Containers-Immersion/lab05-eks-cluster/mythicaleks.yaml)"
fi
nc=$(kubectl get nodes | grep Ready | wc -l)
if [[ $nc -lt 3 ]]; then
    echo "ERROR: expected 3x Ready EKS nodes got $nc"
else
    echo "PASSED: 3x Ready EKS nodes got $nc"
fi
pc=$(kubectl get pods -n kube-system | grep Running | wc -l)
if [[ $pc -lt 8 ]]; then
    echo "ERROR: expected 8x running pods in kube-system got $pc"
else
    echo "PASSED: 8x  running pods in kube-system got $pc"
fi
