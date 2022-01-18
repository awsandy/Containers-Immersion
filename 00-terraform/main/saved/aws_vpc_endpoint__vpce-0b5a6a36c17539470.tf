# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_vpc_endpoint.vpce-0b5a6a36c17539470:
resource "aws_vpc_endpoint" "vpce-0b5a6a36c17539470" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
      Version = "2012-10-17"
    }
  )
  private_dns_enabled = false
  route_table_ids = [
    aws_route_table.rtb-06698bce9521fa86f.id,
    aws_route_table.rtb-0ad5d385f3aa39dff.id,
  ]
  security_group_ids = []
  service_name       = "com.amazonaws.eu-west-1.dynamodb"
  subnet_ids         = []
  tags               = {}
  tags_all           = {}
  vpc_endpoint_type  = "Gateway"
  vpc_id             = aws_vpc.vpc-0a81be22c25965108.id

  timeouts {}
}