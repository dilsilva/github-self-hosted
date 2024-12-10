module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project}-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  #Single NAT Gateway https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/v5.16.0?tab=readme-ov-file#single-nat-gateway
  enable_nat_gateway = true
  single_nat_gateway = true

  create_database_subnet_group    = false
  create_elasticache_subnet_group = false
  create_redshift_subnet_group    = false
  manage_default_network_acl      = false
  manage_default_route_table      = false
  manage_default_security_group   = false

  default_vpc_tags = merge(
    var.default_tags, {
      Name = "vpc"
    },
  )
}

module "runner" {
  source     = "./modules/runner"
  runner_ami = var.ami_id
  region     = var.region

  instance_type = var.instance_type

  aws_ecs_service_name       = module.ecs.service_name
  aws_ecs_cluster_name       = module.ecs.cluster_name
  is_lb_private              = "false"
  runner_host_key_pair       = module.suplement.key_pair_name
  runner_iam_policy_name     = "${var.project}RunnerHostPolicy"
  create_dns_record          = "false"
  vpc_id                     = module.vpc.vpc_id
  elb_subnets                = module.vpc.public_subnets
  auto_scaling_group_subnets = module.vpc.private_subnets

  github_url           = "https://github.com/dilsilva/surepay/settings/actions/runners"
  github_owner         = "dilsilva"
  github_repo          = "surepay"
  ssm_parameter_name   = module.suplement.ssm_parameter_name
  github_runner_group  = ""
  github_runner_labels = ""

  tags = merge(
    var.default_tags, {
      "name" = "${var.project}-runner"
  }, )

  depends_on = [module.vpc, module.suplement]
}


module "ecs" {
  source = "./modules/ecs"

  project         = var.project
  region          = var.region
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  app_name        = var.app_name
  app_image       = module.suplement.ecr_repository

  private_instances_security_group = module.runner.private_instances_security_group

  depends_on = [module.vpc, module.suplement]
}

module "suplement" {
  source     = "./modules/suplement"
  project    = var.project
  public_key = ""
  pat_value  = ""
  app_name   = var.app_name
}
