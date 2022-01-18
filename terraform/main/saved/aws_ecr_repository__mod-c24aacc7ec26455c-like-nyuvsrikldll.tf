# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_ecr_repository.mod-c24aacc7ec26455c-like-nyuvsrikldll:
resource "aws_ecr_repository" "mod-c24aacc7ec26455c-like-nyuvsrikldll" {
  image_tag_mutability = "MUTABLE"
  name                 = "mod-c24aacc7ec26455c-like-nyuvsrikldll"
  tags                 = {}
  tags_all             = {}

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = false
  }

  timeouts {}
}
