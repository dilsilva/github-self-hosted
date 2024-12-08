locals {
  security_group = join("", flatten([aws_security_group.runner_host_security_group[*].id, var.runner_security_group_id]))
}


resource "aws_iam_instance_profile" "runner_host_profile" {
  role = aws_iam_role.runner_host_role.name
  path = "/"
}

resource "aws_launch_template" "runner_launch_template" {
  name_prefix            = var.project
  image_id               = var.runner_ami != "" ? var.runner_ami : data.aws_ami.ubuntu-linux-2404.id
  instance_type          = var.instance_type
  update_default_version = true

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    security_groups             = concat([local.security_group], var.runner_additional_security_groups)
    delete_on_termination       = true
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.runner_host_profile.name
  }
  
  key_name = var.runner_host_key_pair

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    aws_region         = var.region
    github_url         = var.github_url
    github_owner       = var.github_owner
    github_repo        = var.github_repo
    ssm_parameter_name = var.ssm_parameter_name
    runner_group       = var.github_runner_group
    runner_labels      = var.github_runner_labels
  }))

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = var.disk_size
      volume_type           = "gp2"
      delete_on_termination = true
      encrypted             = var.disk_encrypt
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge(tomap({ "Name" = var.runner_launch_template_name }), merge(var.tags))
  }

  tag_specifications {
    resource_type = "volume"
    tags          = merge(tomap({ "Name" = var.runner_launch_template_name }), merge(var.tags))
  }

  metadata_options {
    http_endpoint               = var.http_endpoint ? "enabled" : "disabled"
    http_tokens                 = var.use_imds_v2 ? "required" : "optional"
    http_put_response_hop_limit = var.http_put_response_hop_limit
    instance_metadata_tags      = var.enable_instance_metadata_tags ? "enabled" : "disabled"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "runner_auto_scaling_group" {
  name_prefix = "ASG-${var.project}"
  launch_template {
    id      = aws_launch_template.runner_launch_template.id
    version = aws_launch_template.runner_launch_template.latest_version
  }
  max_size         = var.runner_instance_count_max
  min_size         = var.runner_instance_count_min
  desired_capacity = var.runner_instance_count

  vpc_zone_identifier = var.auto_scaling_group_subnets

  default_cooldown          = 180
  health_check_grace_period = 180
  health_check_type         = "EC2"

  target_group_arns = var.create_elb ? [
    aws_lb_target_group.runner_lb_target_group[0].arn,
  ] : null

  termination_policies = [
    "OldestLaunchConfiguration",
  ]

  dynamic "tag" {
    for_each = var.tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  tag {
    key                 = "Name"
    value               = "ASG-${var.project}"
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
  }

  lifecycle {
    create_before_destroy = true
  }

}
