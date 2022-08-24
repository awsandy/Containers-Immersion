data "aws_ecs_cluster" "current" {
  cluster_name = var.cn
}

data "aws_ecs_service" "current" {
  service_name = var.sn
  cluster_arn  = data.aws_ecs_cluster.current.arn
}