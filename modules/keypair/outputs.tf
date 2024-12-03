output "key_pair_name" {
  description = "The name of the key for the EC2"
  value       = aws_key_pair.keypair.key_name
}

output "key_pair_arn" {
  description = "The ARN of the key for the EC2"
  value       = aws_key_pair.keypair.arn
}