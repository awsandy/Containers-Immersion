source ~/.bash_profile


# ------  resize OS disk -----------

# Specify the desired volume size in GiB as a command-line argument. If not specified, default to 20 GiB.
VOLUME_SIZE=${1:-32}

# Get the ID of the environment host Amazon EC2 instance.
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data//instance-id)

# Get the ID of the Amazon EBS volume associated with the instance.
VOLUME_ID=$(aws ec2 describe-instances \
  --instance-id $INSTANCE_ID \
  --query "Reservations[0].Instances[0].BlockDeviceMappings[0].Ebs.VolumeId" \
  --output text)

# Resize the EBS volume.
aws ec2 modify-volume --volume-id $VOLUME_ID --size $VOLUME_SIZE

# Wait for the resize to finish.
while [ \
  "$(aws ec2 describe-volumes-modifications \
    --volume-id $VOLUME_ID \
    --filters Name=modification-state,Values="optimizing","completed" \
    --query "length(VolumesModifications)"\
    --output text)" != "1" ]; do
sleep 1
done

if [ $(readlink -f /dev/xvda) = "/dev/xvda" ]
then
  # Rewrite the partition table so that the partition takes up all the space that it can.
  sudo growpart /dev/xvda 1
 
  # Expand the size of the file system.
  sudo resize2fs /dev/xvda1

else
  # Rewrite the partition table so that the partition takes up all the space that it can.
  sudo growpart /dev/nvme0n1 1

  # Expand the size of the file system.
  # sudo resize2fs /dev/nvme0n1p1 #(Amazon Linux 1)
  sudo xfs_growfs /dev/nvme0n1p1 #(Amazon Linux 2)
fi

test -n "$AWS_REGION" && echo "PASSED: AWS_REGION is $AWS_REGION" || echo AWS_REGION is not set !!
test -n "$TF_VAR_region" && echo "PASSED: TF_VAR_region is $TF_VAR_region" || echo TF_VAR_region is not set !!
test -n "$ACCOUNT_ID" && echo "PASSED: ACCOUNT_ID is $ACCOUNT_ID" || echo ACCOUNT_ID is not set !!
echo "setup tools run" >> ~/setup-tools.log

cd ~/environment/tfekscode/Launch/lb2
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json -s

cd $this
#
# final checks
#