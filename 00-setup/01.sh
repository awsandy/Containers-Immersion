cd ~/environment
git clone https://github.com/aws-samples/amazon-ecs-mythicalmysfits-workshop.git
cd amazon-ecs-mythicalmysfits-workshop/workshop-1
script/setup
export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
echo "export ACCOUNT_ID=${ACCOUNT_ID}" >> ~/.bash_profile
echo "export AWS_REGION=${AWS_REGION}" >> ~/.bash_profile
aws configure set default.region ${AWS_REGION}
aws configure get default.region
echo "ssh key"
if [ ! -f ~/.ssh/id_rsa ]; then
  mkdir -p ~/.ssh
  ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""
  chmod 600 ~/.ssh/id*
fi
aws ec2 import-key-pair --key-name "mythicaleks" --public-key-material file://~/.ssh/id_rsa.pub

