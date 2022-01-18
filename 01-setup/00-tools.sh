sudo pip install --upgrade awscli && hash -r
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv -v /tmp/eksctl /usr/local/bin
sudo curl --silent --location -o /usr/local/bin/kubectl \
https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
sudo chmod +x /usr/local/bin/kubectl
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
sudo yum -y install gettext bash-completion moreutils
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

