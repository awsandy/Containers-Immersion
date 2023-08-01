sudo pip install --upgrade awscli && hash -r
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv -v /tmp/eksctl /usr/local/bin
echo "Setup kubectl"
if [ ! `which kubectl 2> /dev/null` ]; then
  echo "Install kubectl v1.24.12"
  curl --silent -LO https://storage.googleapis.com/kubernetes-release/release/v1.24.12/bin/linux/amd64/kubectl  > /dev/null
  chmod +x ./kubectl
  sudo mv ./kubectl  /usr/local/bin/kubectl > /dev/null
fi
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
sudo yum -y install gettext bash-completion moreutils jq
kubectl completion bash >>  ~/.bash_completion
eksctl completion bash >> ~/.bash_completion
. ~/.bash_completion
echo 'yq() {
docker run --rm -i -v "${PWD}":/workdir mikefarah/yq yq "$@"
}' | tee -a ~/.bashrc && source ~/.bashrc
for command in kubectl jq envsubst aws eksctl kubectl helm
do
    which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND"
done
echo "check sts"
aws sts get-caller-identity --query Arn | grep TeamRole
if [[ $? -ne 0 ]];then
    echo "Check AWS temporary switch - and EC2 assigned to TeamRole"
fi

