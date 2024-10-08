module "vpc" {
  source = "/workspaces/terraform-modules/workspace/modules/vpc"
  #aws_region = var.aws_region
  cidr_block = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone = var.availability_zone 
  enable_nat_gateway = var.enable_nat_gateway
}


module "eks" {
  source = "/workspaces/terraform-modules/workspace/modules/eks"
  
  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  public_subnet_id = module.vpc.public_subnet_id
  cluster_endpoint_private_access= var.cluster_endpoint_private_access
  cluster_endpoint_public_access = var.cluster_endpoint_public_access
  cluster_public_access_cidrs = var.cluster_public_access_cidrs
  cluster_authentication_mode = var.cluster_authentication_mode
  cluster_admin_permission = var.cluster_admin_permission
  clsuter_enabled_cluster_log_types = var.cluster_enabled_cluster_log_types
  service_ipv4_cidr = var.service_ipv4_cidr
  node_group_ami_type = var.node_group_ami_type
  node_group_capacity_type = var.capacity_type
  node_group_disk_size = var.node_group_disk_size
  node_group_instances_type = var.eks_instances_type
  node_group_name = var.node_group_name
  ec2_ssh_key = var.ec2_ssh_key
  node_group_min_size = var.node_group_min_size
  node_group_max_size = var.node_group_max_size
  node_group_desired_size = var.node_group_desired_size
  vpc_id = module.vpc.aws_vpc_id

  depends_on = [ module.vpc ]

}

