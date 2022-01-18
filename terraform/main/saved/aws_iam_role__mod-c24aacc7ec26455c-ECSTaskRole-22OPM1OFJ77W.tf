# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_iam_role.mod-c24aacc7ec26455c-ECSTaskRole-22OPM1OFJ77W:
resource "aws_iam_role" "mod-c24aacc7ec26455c-ECSTaskRole-22OPM1OFJ77W" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = [
              "ecs-tasks.amazonaws.com",
              "ec2.amazonaws.com",
            ]
          }
        },
      ]
      Version = "2008-10-17"
    }
  )
  force_detach_policies = false
  managed_policy_arns   = []
  max_session_duration  = 3600
  name                  = "mod-c24aacc7ec26455c-ECSTaskRole-22OPM1OFJ77W"
  path                  = "/"
  tags                  = {}
  tags_all              = {}

  inline_policy {
    name = "AmazonECSTaskRolePolicy"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "logs:CreateLogStream",
              "logs:CreateLogGroup",
              "logs:PutLogEvents",
            ]
            Effect   = "Allow"
            Resource = "*"
          },
          {
            Action = [
              "dynamodb:Scan",
              "dynamodb:Query",
              "dynamodb:UpdateItem",
              "dynamodb:GetItem",
            ]
            Effect   = "Allow"
            Resource = "arn:aws:dynamodb:eu-west-1:479455118968:table/Table-mod-c24aacc7ec26455c"
          },
        ]
      }
    )
  }
}
