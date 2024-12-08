variable "project" {
  type        = string
  description = "Name of the project"
  default     = "surepay"
}
variable "region" {
  type        = string
  description = "Region of the project"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets of the VPC"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnets of the VPC"
}

variable "app_name" {
  type        = string
  description = "Name of the APP"
}

variable "app_image" {
  type        = string
  description = "Image of the APP"
}

variable "private_instances_security_group" {
  type        = string
  description = "ID of the SG used for internal communication between instances"
}
