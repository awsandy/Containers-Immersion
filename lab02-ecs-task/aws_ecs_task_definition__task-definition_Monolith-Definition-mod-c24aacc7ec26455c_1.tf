# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_ecs_task_definition.task-definition_Monolith-Definition-mod-c24aacc7ec26455c_1:
resource "aws_ecs_task_definition" "task-definition_Monolith-Definition-mod" {
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
            value = var.tn
          },
          {
            name  = "UPSTREAM_URL"
            value = var.lb
          },
        ]
        environmentFiles = []
        essential        = true
        extraHosts       = []
        image            = format("%s:latest",var.ruri)
        links            = []
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = var.lgn
            awslogs-region        = data.aws_region.current.name
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
  family             = format("Monolith-Definition-mod-%s",var.muid)
  memory             = "512"
  network_mode       = "awsvpc"
  requires_compatibilities = [
    "FARGATE",
  ]
  tags          = {}
  tags_all      = {}
  task_role_arn = var.etr
}