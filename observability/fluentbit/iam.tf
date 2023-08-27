resource "aws_iam_role" "role-fluent-bit" {
  name                  = "role-fluent-bit"
  force_detach_policies = true
  max_session_duration  = 3600
  path                  = "/"
  assume_role_policy    = jsonencode(
    {
      "Version": "2012-10-17"
      "Statement": [
        {
          "Effect": "Allow"
          "Principal": {
              "Federated": format("%s",data.aws_iam_openid_connect_provider.example.arn)
          }
          "Action": "sts:AssumeRoleWithWebIdentity"
        }
      ]
    }
 )
}


resource "aws_iam_role" "role-cloudwatch-agent" {
  name                  = "role-cloudwatch-agent"
  force_detach_policies = true
  max_session_duration  = 3600
  path                  = "/"
  assume_role_policy    = jsonencode(
    {
      "Version": "2012-10-17"
      "Statement": [
        {
          "Effect": "Allow"
          "Principal": {
              "Federated": format("%s",data.aws_iam_openid_connect_provider.example.arn)
          }
          "Action": "sts:AssumeRoleWithWebIdentity"
        }
      ]
    }
 )
}



# policy is same as CloudWatchAgentServerPolicy
# except - includes Put RetentionPolicy - and doesn't have * for Resource
resource "aws_iam_policy" "policy_sa_logs" {
  name        = "policy-sa-fluent-bit-logs"
  path        = "/"
  description = "policy for EKS Service Account fluent-bit "
  policy = data.aws_iam_policy_document.example.json
}

######## Policy attachment to IAM role ########

resource "aws_iam_role_policy_attachment" "policy-attach1" {
  role       = aws_iam_role.role-fluent-bit.name
  policy_arn = aws_iam_policy.policy_sa_logs.arn
}

resource "aws_iam_role_policy_attachment" "policy-attach2" {
  role       = aws_iam_role.role-fluent-bit.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}


resource "aws_iam_role_policy_attachment" "policy-attach3" {
  role       = aws_iam_role.role-cloudwatch-agent.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

data "aws_iam_policy_document" "example" {
  statement {
    effect = "Allow" # the default
    actions = [
                "cloudwatch:PutMetricData",
                "ec2:DescribeVolumes",
                "ec2:DescribeTags",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams",
                "logs:DescribeLogGroups",
                "logs:CreateLogStream",
                "logs:CreateLogGroup",
                "logs:PutRetentionPolicy"
    ]
    resources = [format("arn:aws:logs:%s:%s:*:*",data.aws_region.current.name,data.aws_caller_identity.current.account_id)]
  }
}


    