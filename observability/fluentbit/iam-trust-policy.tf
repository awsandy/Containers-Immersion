data "aws_iam_policy_document" "trust-fluent" {
  statement {
    effect = "Allow" # the default
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.example.arn]
    }
    condition {
        #test = "ForAnyValue:StringEquals"
        test = "StringEquals"
        variable = format("%s:aud",data.aws_iam_openid_connect_provider.example.url)
        values = ["sts.amazonaws.com"]
    }
    condition {
        #test = "ForAnyValue:StringEquals"
        test = "StringEquals"
        variable = format("%s:sub",data.aws_iam_openid_connect_provider.example.url)
        values = [format("system:serviceaccount:%s:%s",kubernetes_namespace.cw.metadata[0].name,kubernetes_service_account_v1.fluent-bit.metadata[0].name)]
    }
  }
}
