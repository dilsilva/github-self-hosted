resource "aws_security_group" "ecs_lb" {
    description = "Security group of LB for ECS"
  name   = "${var.project}-ecs-lb"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self        = "false"
    cidr_blocks = ["0.0.0.0/0"]
    description = "any"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    self        = "false"
    cidr_blocks = ["0.0.0.0/0"]
    description = "any"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs" {
  description = "Security group for ECS workloads"
  name   = "${var.project}-ecs"
  vpc_id = var.vpc_id

}

resource "aws_security_group_rule" "lb_runner_tcp" {
  description = "Incoming shh traffic from LB to ECS"
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "TCP"

  security_group_id        = aws_security_group.ecs.id
  source_security_group_id = var.private_instances_security_group == "" ? aws_security_group.ecs.id : var.private_instances_security_group
}

resource "aws_security_group_rule" "lb_runner_ssh" {
  description = "Incoming SSH traffic from LB to ecs"
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "TCP"

  security_group_id        = aws_security_group.ecs.id
  source_security_group_id = aws_security_group.ecs_lb.id
}

resource "aws_security_group_rule" "lb_runner_ssl" {
  description = "Incoming ssl traffic from LB to ecs"
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "TCP"

  security_group_id        = aws_security_group.ecs.id
  source_security_group_id = aws_security_group.ecs_lb.id
}

resource "aws_security_group_rule" "egress_runner" {
  description = "Outbound traffic from runner to instances"
  type        = "egress"
  from_port   = "0"
  to_port     = "65535"
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.ecs.id
}


#LB

resource "aws_lb" "ecs_alb" {
  name               = "${var.project}-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [for subnet in var.public_subnets : subnet]
  security_groups    = [aws_security_group.ecs_lb.id]

  depends_on = [ aws_security_group.ecs_lb ]
  tags = {
    Name = "ecs-alb"
  }
}

resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  depends_on = [ aws_security_group.ecs_lb ]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = "${var.project}-ecs-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  depends_on = [ aws_security_group.ecs_lb ]

  health_check {
    path = "/"
  }
}