# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_ecs_task_definition.task-definition_Monolith-Definition-mod-c24aacc7ec26455c_1:
resource "aws_ecs_task_definition" "task-definition_Monolith-Definition-mod-c24aacc7ec26455c_1" {
  container_definitions = jsonencode(
    [
      {
        command               = []
        cpu                   = 0
        dnsSearchDomains      = []
        dnsServers            = []
        dockerLabels          = {}
        dockerSecurityOptions = []
        entryPoint            = []
        environment = [
          {
            name  = "DDB_TABLE_NAME"
            value = "Table-mod-c24aacc7ec26455c"
          },
          {
            name  = "UPSTREAM_URL"
            value = var.lb
          },
        ]
        environmentFiles = []
        essential        = true
        extraHosts       = []
        image            = "nginx:latest"
        links            = []
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = var.lgn
            awslogs-region        = "eu-west-1"
            awslogs-stream-prefix = "awslogs-mythicalmysfits-service"
          }
          secretOptions = []
        }
        mountPoints = []
        name        = "monolith-service"
        portMappings = [
          {
            containerPort = 80
            hostPort      = 80
            protocol      = "tcp"
          },
        ]
        secrets        = []
        systemControls = []
        ulimits        = []
        volumesFrom    = []
      },
    ]
  )
  cpu                = "256"
  execution_role_arn = var.esr
  family             = "Monolith-Definition-mod-c24aacc7ec26455c"
  memory             = "512"
  network_mode       = "awsvpc"
  requires_compatibilities = [
    "FARGATE",
  ]
  tags          = {}
  tags_all      = {}
  task_role_arn = var.etr
}