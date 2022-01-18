data "aws_security_group" "sg-0fc5cc8db2ea5d68b" {
  name   = "default"
  vpc_id = aws_vpc.vpc-0ef9c60aaf76a3fc6.id
}
