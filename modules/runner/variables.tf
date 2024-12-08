variable "project" {
  type        = string
  description = "Name of the project"
  default     = "surepay"
}

variable "associate_public_ip_address" {
  type    = bool
  default = false
}

variable "auto_scaling_group_subnets" {
  type        = list(string)
  description = "List of subnets where the Auto Scaling Group will deploy the instances"
}

variable "runner_additional_security_groups" {
  type        = list(string)
  description = "List of additional security groups to attach to the launch template"
  default     = []
}

variable "runner_ami" {
  type        = string
  description = "The AMI that the runner Host will use."
  default     = ""
}

variable "runner_host_key_pair" {
  type        = string
  description = "Select the key pair to use to launch the runner host"
}

variable "runner_iam_policy_name" {
  type        = string
  description = "IAM policy name to create for granting the instance role access to the bucket"
  default     = "runnerHost"
}

variable "runner_iam_role_name" {
  type        = string
  description = "IAM role name to create"
  default     = "runnerRole"
}

variable "runner_instance_count" {
  type    = number
  default = 1
}

variable "runner_instance_count_min" {
  type    = number
  default = 1
}

variable "runner_instance_count_max" {
  type    = number
  default = 3
}

variable "runner_launch_template_name" {
  type        = string
  description = "runner Launch template Name, will also be used for the ASG"
  default     = "runner-lt"
}

variable "runner_record_name" {
  type        = string
  description = "DNS record name to use for the runner"
  default     = ""
}

variable "runner_security_group_id" {
  type        = string
  description = "Custom security group to use"
  default     = ""
}

variable "cidrs" {
  type        = list(string)
  description = "List of CIDRs that can access the runner. Default: 0.0.0.0/0"

  default = [
    "0.0.0.0/0",
  ]
}

variable "create_dns_record" {
  type        = bool
  description = "Choose if you want to create a record name for the runner (LB). If true, 'hosted_zone_id' and 'runner_record_name' are mandatory"
}

variable "create_elb" {
  type        = bool
  description = "Choose if you want to deploy an ELB for accessing runner hosts. If true, you must set elb_subnets and is_lb_private"
  default     = true
}

variable "disk_encrypt" {
  type        = bool
  description = "Instance EBS encryption"
  default     = true
}

variable "disk_size" {
  type        = number
  description = "Root EBS size in GB"
  default     = 100
}

variable "elb_subnets" {
  type        = list(string)
  description = "List of subnets where the ELB will be deployed"
  default     = []
}

variable "enable_instance_metadata_tags" {
  type        = bool
  description = "Enables or disables access to instance tags from the instance metadata service"
  default     = false
}

variable "hosted_zone_id" {
  type        = string
  description = "Name of the hosted zone where we'll register the runner DNS name"
  default     = ""
}

variable "http_endpoint" {
  type        = bool
  description = "Whether the metadata service is available"
  default     = true
}

variable "http_put_response_hop_limit" {
  type        = number
  description = "The desired HTTP PUT response hop limit for instance metadata requests"
  default     = 1
}

variable "instance_type" {
  type        = string
  description = "Instance size of the runner"
  default     = "t3.nano"
}


variable "is_lb_private" {
  type        = bool
  nullable    = true
  default     = null
  description = "If TRUE, the load balancer scheme will be \"internal\" else \"internet-facing\""
}

variable "private_ssh_port" {
  type        = number
  description = "Set the SSH port to use between the runner and private instance"
  default     = 22
}

variable "public_ssh_port" {
  type        = number
  description = "Set the SSH port to use from desktop to the runner"
  default     = 22
}

variable "region" {
  type = string
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign"
}

variable "use_imds_v2" {
  type        = bool
  description = "Use (IMDSv2) Instance Metadata Service V2"
  default     = false
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where we'll deploy the runner"
}

# variable "ipv4_cidr_block" {
#   type        = list(string)
#   default     = [""]
#   description = "List of ipv4 CIDR blocks from the subnet"
# }

variable "github_url" {
  type        = string
  default     = ""
  description = "GitHub full URL.<br>Example: \"https://github.com/cloudandthings/repo\"."
}

variable "github_owner" {
  type        = string
  default     = ""
  description = "GitHub repository owner."
}

variable "github_repo" {
  type        = string
  default     = ""
  description = "GitHub repository name."
}

variable "ssm_parameter_name" {
  type        = string
  default     = ""
  description = "SSM parameter name for the GitHub Runner token.<br>Example: \"/github/runner/token\"."
}

variable "github_runner_group" {
  type        = string
  default     = ""
  description = "Custom GitHub runner group."
}

variable "github_runner_labels" {
  type        = string
  default     = ""
  description = "Custom GitHub runner labels. <br>Example: `\"gpu,x64,linux\"`."
}

variable "aws_ecs_cluster_name" {
  type        = string
  default     = ""
  description = "Name of the ECS Cluster where the operations gonna be executed"
}

variable "aws_ecs_service_name" {
  type        = string
  default     = ""
  description = "Name of the ECS service where the operations gonna be executed"
}