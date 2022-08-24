data "aws_subnet" "selected" {
  vpc_id = data.aws_vpc.default.id
  #availability_zone= "eu-west-1a"
    filter {
    name   = "tag:Name"
    values = ["pub-default2"]
  }
}