resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-keypair"
  public_key = var.public_key
}

resource "aws_ssm_parameter" "pat" {
  name  = "PERSONAL_ACCESS_TOKEN"
  type  = "String"
  value = var.pat_value
}

resource "aws_ecr_repository" "ecr" {
  name                 = var.app_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}