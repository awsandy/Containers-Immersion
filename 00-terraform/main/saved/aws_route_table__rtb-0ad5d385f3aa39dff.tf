# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_route_table.rtb-0ad5d385f3aa39dff:
resource "aws_route_table" "rtb-0ad5d385f3aa39dff" {
  propagating_vgws = []
  route = [
    {
      carrier_gateway_id         = ""
      cidr_block                 = "0.0.0.0/0"
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      gateway_id                 = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      nat_gateway_id             = aws_nat_gateway.nat-05a205b33c62494bb.id
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
      core_network_arn = ""
    },
  ]
  tags     = {}
  tags_all = {}
  vpc_id   = aws_vpc.vpc-0a81be22c25965108.id

  timeouts {}
}
