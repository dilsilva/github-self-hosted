module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project}-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true

  default_vpc_tags = merge(
    var.default_tags, {
      Name = "SurepayVPC"
    },
  )
}

module "runner" {
  source                = "./modules/runner"

  ami_id                = var.ami_id
  vpc_id                = module.vpc.vpc_id
  runner_instance_type  = "t2.micro"
  subnet_id             = tostring(module.vpc.public_subnets[0])
  default_tags = merge(
    var.default_tags, {
      Name = "gh-runner"
    },
  )
}