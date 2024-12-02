variable "project" {
  default = "surepay"
}

variable "region" {
  default = "eu-west-1"
}

variable "default_tags" {
  default = {

    Environment = "Dev"
    Owner       = "Surepay"
    Project     = "Surepay"

  }
  description = "Default Tags for Project"
  type        = map(string)
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  type    = string
}

variable "private_subnets" {
  default = ["10.0.1.0/24"]
  type    = list(string)
}
variable "public_subnets" {
  default = ["10.0.101.0/24"]
  type    = list(string)
}
variable "azs" {
  default = ["eu-west-1a"]
  type    = list(string)
}


#Runner
variable "ami_id" {
  default = "ami-0e9085e60087ce171"
  type    = string
}
