# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_route_table_association.subnet-087318f7306293146__rtbassoc-09992fc7e97a82d3f:
resource "aws_route_table_association" "subnet-087318f7306293146__rtbassoc-09992fc7e97a82d3f" {
  route_table_id = aws_route_table.rtb-0c326cbb7444a14f7.id
  subnet_id      = aws_subnet.subnet-087318f7306293146.id
}