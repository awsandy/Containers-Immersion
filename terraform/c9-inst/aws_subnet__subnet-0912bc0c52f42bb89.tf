# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_subnet.subnet-0912bc0c52f42bb89:
resource "aws_subnet" "subnet-0912bc0c52f42bb89" {
  assign_ipv6_address_on_creation = false
  availability_zone               = "eu-west-1a"
  cidr_block                      = "172.31.32.0/20"
  map_public_ip_on_launch         = true
  tags                            = {}
  tags_all                        = {}
  vpc_id                          = aws_vpc.vpc-0ef9c60aaf76a3fc6.id

  timeouts {}
}
