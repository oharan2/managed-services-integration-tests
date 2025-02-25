variable "aws_region" {
  type        = string
  description = "The region to create the ROSA cluster in"
}

variable "az_ids" {
  type = list
  description = "A list of region-mapped AZ IDs that a subnet should get deployed into"
}

variable "cluster_name" {
  type        = string
  description = "The name of the ROSA cluster to create"
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "< 6.0.0"

  name = "${var.cluster_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = var.az_ids
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
}

output "cluster-private-subnet" {
  value = module.vpc.private_subnets[0]
}

output "cluster-public-subnet" {
  value = module.vpc.public_subnets[0]
}

output "node-private-subnet" {
  value = module.vpc.private_subnets[1]
}
