echo "Install OS tools"
sudo yum -y -q -e 0 install  jq moreutils nmap > /dev/null
echo "Update pip"
sudo pip install --upgrade pip 2&> /dev/null
echo "Uninstall AWS CLI v1"
sudo /usr/local/bin/pip uninstall awscli -y 2&> /dev/null
sudo pip uninstall awscli -y 2&> /dev/null
echo "Install AWS CLI v2"
curl --silent "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" > /dev/null
rm -rf aws
unzip -qq awscliv2.zip
sudo ./aws/install
sudo ./aws/install --update
sudo rm -f /usr/bin/aws
sudo ln -s /usr/local/aws-cli/v2/current/bin/aws /usr/bin/aws
rm -f awscliv2.zip
rm -rf aws
aws --version