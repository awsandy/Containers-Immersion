# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_iam_role.TeamRole:
resource "aws_iam_role" "TeamRole" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        #{
        #  Action = "sts:AssumeRole"
        #  Effect = "Allow"
        #  Principal = {
        #    "AWS" = format("arn:aws:iam::%s:user/EEOverlord", data.aws_caller_identity.current.account_id)
        #  }
        #},
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
          Sid = "c24aacc7ec26455cbc6a0976b8e00ce0"
        },
      ]
      Version = "2012-10-17"
    }
  )
  force_detach_policies = false

  max_session_duration = 43200
  name                 = "TeamRole"
  path                 = "/"
  tags                 = {}
  tags_all             = {}

  inline_policy {
    name = "c24aacc7ec26455cbc6a0976b8e00ce0-cfn-deny"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "cloudformation:CancelUpdateStack",
              "cloudformation:ContinueUpdateRollback",
              "cloudformation:CreateChangeSet",
              "cloudformation:DeleteStack",
              "cloudformation:GetTemplate",
              "cloudformation:GetTemplateSummary",
              "cloudformation:SetStackPolicy",
              "cloudformation:UpdateStack",
              "cloudformation:UpdateTerminationProtection",
            ]
            Effect   = "Deny"
            Resource = "arn:aws:cloudformation:eu-west-1:479455118968:stack/mod-c24aacc7ec26455c/20681050-7707-11ec-97ed-06081b2904f9"
          },
        ]
        Version = "2012-10-17"
      }
    )
  }
}
