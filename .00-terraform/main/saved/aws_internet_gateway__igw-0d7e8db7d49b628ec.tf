# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_internet_gateway.igw-0d7e8db7d49b628ec:
resource "aws_internet_gateway" "igw-0d7e8db7d49b628ec" {
  tags     = {}
  tags_all = {}
  vpc_id   = aws_vpc.vpc-0a81be22c25965108.id
}