output "runner_auto_scaling_group_name" {
  description = "The name of the Auto Scaling Group for runner hosts"
  value       = aws_autoscaling_group.runner_auto_scaling_group.name
}

output "runner_elb_id" {
  description = "The ID of the ELB for runner hosts"
  value       = var.create_elb ? try(aws_lb.runner_lb[0].id, null) : null
}

output "runner_host_security_group" {
  description = "The ID of the runner host security group"
  value       = aws_security_group.runner_host_security_group[*].id
}

output "elb_arn" {
  description = "The ARN of the ELB for runner hosts"
  value       = var.create_elb ? try(aws_lb.runner_lb[0].arn, null) : null
}

output "elb_ip" {
  description = "The DNS name of the ELB for runner hosts"
  value       = var.create_elb ? try(aws_lb.runner_lb[0].dns_name, null) : null
}

output "private_instances_security_group" {
  description = "The ID of the security group for private instances"
  value       = aws_security_group.private_instances_security_group.id
}

output "target_group_arn" {
  description = "The ARN of the target group for the ELB"
  value       = var.create_elb ? try(aws_lb_target_group.runner_lb_target_group[0].arn, null) : null
}
