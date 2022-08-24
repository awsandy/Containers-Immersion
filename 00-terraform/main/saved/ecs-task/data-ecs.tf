data "aws_ecs_cluster" "current" {
  cluster_name = var.cn
}