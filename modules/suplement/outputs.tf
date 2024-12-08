output "key_pair_name" {
  description = "The name of the key for the EC2"
  value       = aws_key_pair.keypair.key_name
}

output "key_pair_arn" {
  description = "The ARN of the key for the EC2"
  value       = aws_key_pair.keypair.arn
}

output "ssm_parameter_name" {
  description = "The value of the parameter."
  value       = aws_ssm_parameter.pat.name
}

output "ecr_repository" {
  description = " The URL of the repository (in the form aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName)."
  value       = aws_ecr_repository.ecr.repository_url
}