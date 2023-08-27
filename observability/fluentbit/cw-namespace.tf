resource "kubernetes_namespace" "cw" {
  metadata {
    name = "amazon-cloudwatch"
  }

  timeouts {
    delete = "20m"
  }
}

resource "kubernetes_service_account_v1" "cloudwatch-agent" {
  metadata {
    name = "cloudwatch-agent"
    namespace = "amazon-cloudwatch"
    annotations = {
      "eks.amazonaws.com/role_arn" = aws_iam_role.role-cloudwatch-agent.arn
    }
  }
  automount_service_account_token = true # needs to be set
}

resource "kubernetes_service_account_v1" "fluent-bit" {
  metadata {
    name = "fluent-bit"
    namespace = "amazon-cloudwatch"
    annotations = {
      "eks.amazonaws.com/role_arn" = aws_iam_role.role-fluent-bit.arn
    }
  }
  automount_service_account_token = true 
}

