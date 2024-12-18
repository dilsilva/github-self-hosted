#Global

variable "project" {
  default = "surepay"
}

variable "region" {
  default = "eu-west-1"
}

variable "default_tags" {
  default = {

    Environment = "Dev"
    Owner       = "surepay"
    Project     = "surepay"

  }
  description = "Default Tags for Project"
  type        = map(string)
}

#VPC
variable "vpc_cidr" {
  default = "10.0.0.0/16"
  type    = string
}

variable "private_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
  type    = list(string)
}

variable "public_subnets" {
  default = ["10.0.101.0/24", "10.0.102.0/24"]
  type    = list(string)
}

variable "azs" {
  default = ["eu-west-1a", "eu-west-1b"]
  type    = list(string)

}

#Runner
variable "ami_id" {
  default = "ami-0e9085e60087ce171" #Ubuntu
  type    = string
}

variable "instance_type" {
  default = "t2.medium"
}

variable "app_name" {
  default = "go-app"
}

variable "aws_secret_key" {
  default = "aws_secret_key"
}

variable "aws_access_key" {
  default = ""
}

