
resource "aws_route53_record" "runner_record_name" {
  name    = var.runner_record_name
  zone_id = var.hosted_zone_id
  type    = "A"
  count   = var.create_dns_record && var.create_elb ? 1 : 0

  alias {
    evaluate_target_health = true
    name                   = aws_lb.runner_lb[0].dns_name
    zone_id                = aws_lb.runner_lb[0].zone_id
  }
}

resource "aws_lb" "runner_lb" {
  count = var.create_elb ? 1 : 0

  internal = var.is_lb_private
  name     = "${var.project}-lb"

  subnets            = var.elb_subnets
  security_groups    = [aws_security_group.lb.id]
  load_balancer_type = "network"
  tags               = merge(var.tags)

  lifecycle {
    precondition {
      condition     = !var.create_elb || (length(var.elb_subnets) > 0 && var.is_lb_private != null)
      error_message = "elb_subnets and is_lb_private must be set when creating a load balancer"
    }
  }
}

resource "aws_lb_target_group" "runner_lb_target_group" {
  count = var.create_elb ? 1 : 0

  name        = "${var.project}-lb-target"
  port        = 22
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    port     = "traffic-port"
    protocol = "TCP"
  }

  tags = merge(var.tags)
}

resource "aws_lb_listener" "runner_lb_listener_22" {
  count = var.create_elb ? 1 : 0

  default_action {
    target_group_arn = aws_lb_target_group.runner_lb_target_group[0].arn
    type             = "forward"
  }

  load_balancer_arn = aws_lb.runner_lb[0].arn
  port              = 22
  protocol          = "TCP"
}

#SGs

#LB
resource "aws_security_group" "lb" {
  description = "Enable SSH access to LB via SSH port"
  name        = "${var.project}-ssh-lb"
  vpc_id      = var.vpc_id

  tags = merge(var.tags)
}

resource "aws_security_group_rule" "shh_lb" {
  description = "Incoming traffic to LB"
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "TCP"

  security_group_id = aws_security_group.lb.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "all_egress_lb" {
  description = "Outgoing traffic from lb to runner"
  type        = "egress"
  from_port   = "0"
  to_port     = "65535"
  protocol    = "-1"
  # cidr_blocks = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.lb.id
  source_security_group_id = aws_security_group.runner_host_security_group.id
}

#runner
resource "aws_security_group" "runner_host_security_group" {
  description = "Enable SSH access to the runner host from lb"
  name        = "${var.project}-runner"
  vpc_id      = var.vpc_id

  tags = merge(var.tags)
}


resource "aws_security_group_rule" "lb_runner_ssh" {
  description = "Incoming traffic to runner"
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "TCP"

  security_group_id        = aws_security_group.runner_host_security_group.id
  source_security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "egress_runner" {
  description = "Outgoing traffic from runner to instances"
  type        = "egress"
  from_port   = "0"
  to_port     = "65535"
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.runner_host_security_group.id
  # source_security_group_id = aws_security_group.runner_host_security_group.id
}

#priv
resource "aws_security_group" "private_instances_security_group" {
  description = "Enable SSH access to the Private instances from the runner via SSH port"
  name        = "${var.project}-priv-instances"
  vpc_id      = var.vpc_id

  tags = merge(var.tags)
}

resource "aws_security_group_rule" "ingress_instances" {
  description = "Incoming traffic from runner"
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "TCP"

  security_group_id        = aws_security_group.private_instances_security_group.id
  source_security_group_id = aws_security_group.runner_host_security_group.id
}