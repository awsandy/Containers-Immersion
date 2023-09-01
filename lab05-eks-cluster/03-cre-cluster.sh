rm -f ~/.kube/config/
rm -rf ~/.kube/cache/
tc=$(aws cloud9 describe-environments --environment-id $C9_PID --query environments[0].managedCredentialsStatus --output text)
if [[ $tc != "DISABLED_BY_OWNER" ]];then
  echo "ERROR: Cloud9 Temporary credentials are not disabled - exiting"
  exit
fi
sc=$(aws cloudformation list-stacks | jq -r '.StackSummaries[] | select(.StackName=="eksctl-mythicaleks-eksctl-cluster").StackStatus' | wc -l)
if [[ $sc -gt 0 ]];then
  ss=$(aws cloudformation list-stacks | jq -r '.StackSummaries[] | select(.StackName=="eksctl-mythicaleks-eksctl-cluster").StackStatus')
  (echo $ss | grep -v DELETE_COMPLETE) > /dev/null
  if [[ $? -eq 0 ]];then
    echo "found previous eksctl-mythicaleks stack set that needs cleaning up state = $ss - exiting"
    exit
  fi
  (echo $ss | grep CREATE_COMPLETE) > /dev/null
  if [[ $? -eq 0 ]];then
    echo "found previous eksctl-mythicaleks stack set that needs cleaning up state = $ss - exiting"
    exit
  fi
fi

export AWS_REGION=$(aws configure get region)
echo $AWS_REGION
cat << EOF > mythicaleks.yaml
---
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: mythicaleks-eksctl
  region: ${AWS_REGION}
  version: "1.24"

availabilityZones: ["${AWS_REGION}a", "${AWS_REGION}b", "${AWS_REGION}c"]

managedNodeGroups:
- name: nodegroup
  desiredCapacity: 3
  ssh:
    allow: true
    publicKeyName: mythicaleks

# To enable all of the control plane logs, uncomment below:
# cloudWatch:
#  clusterLogging:
#    enableTypes: ["*"]

EOF


eksctl create cluster -f mythicaleks.yaml
aws eks update-kubeconfig --name mythicaleks-eksctl
kubectl get nodes
helm repo add eks https://aws.github.io/eks-charts
eksctl utils associate-iam-oidc-provider --cluster=mythicaleks-eksctl --approve
