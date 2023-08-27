export service_account=fluent-bit
export namespace=amazon-cloudwatch
account_id=$(aws sts get-caller-identity --query "Account" --output text)
kubectl annotate serviceaccount -n $namespace $service_account eks.amazonaws.com/role-arn=arn:aws:iam::$account_id:role/role-fluent-bit
export service_account=cloudwatch-agent
kubectl annotate serviceaccount -n $namespace $service_account eks.amazonaws.com/role-arn=arn:aws:iam::$account_id:role/role-cloudwatch-agent

