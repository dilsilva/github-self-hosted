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

# module "runner" {
#   source = "./modules/runner"

#   vpc_id    = module.vpc.vpc_id
#   subnet_id = tostring(module.vpc.public_subnets[0])
#   key_pair_name = module.keypair.key_pair_name

#   ami_id               = var.ami_id
#   runner_instance_type = "t2.micro"

#   default_tags = merge(
#     var.default_tags, {
#       Name = "gh-runner"
#     },
#   )
# }

# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 20.0"

#   cluster_name    = "${var.project}-al2023"
#   cluster_version = "1.31"

#   # EKS Addons
#   cluster_addons = {
#     coredns                = {}
#     eks-pod-identity-agent = {}
#     kube-proxy             = {}
#     vpc-cni                = {}
#   }

#   vpc_id     = module.vpc.vpc_id
#   subnet_ids = module.vpc.public_subnets

#   eks_managed_node_groups = {
#     main = {
#       # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
#       instance_types = [var.instance_type]

#       min_size = 1
#       max_size = 3
#       # This value is ignored after the initial creation
#       # https://github.com/bryantbiggs/eks-desired-size-hack
#       desired_size = 1
#     }
#   }

#   tags = merge(
#     var.default_tags, {
#       Name = "eks"
#     },
#   )
# }

module "bastion" {
  source                     = "Guimove/bastion/aws"
  bastion_ami                = "ami-0e9085e60087ce171"
  bucket_name                = "${var.project}-bastion-bucket"
  region                     = var.region
  vpc_id                     = module.vpc.vpc_id
  is_lb_private              = "false"
  bastion_host_key_pair      = module.keypair.key_pair_name
  create_dns_record          = "false"
  bastion_iam_policy_name    = "${var.project}BastionHostPolicy"
  elb_subnets                = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  auto_scaling_group_subnets = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  tags = merge(
    var.default_tags, {
      "name" = "${var.project}-bastion"
  }, )
}

module "keypair" {
  source  = "./modules/keypair"
  project = var.project
}