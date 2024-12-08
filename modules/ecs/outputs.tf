output "service_name" {
  description = "Name of the created ECS service"
  value       = aws_ecs_service.service.name
}
output "cluster_name" {
  description = "Name of the created ECS Cluster"
  value       = aws_ecs_cluster.main.name
}
