##############################
# VPC
##############################

cidr_block = "10.0.0.0/16"
aws_region = "us-east-1"
enable_dns_hostnames = true
enable_dns_support = true
public_subnet_cidr = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidr = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]
enable_nat_gateway = false

################################
# EKS
################################

cluster_name = "eks_terraform_prod"
cluster_version = "1.30"
cluster_endpoint_private_access= false
cluster_endpoint_public_access = true
cluster_enabled_cluster_log_types = ["api", "audit", "scheduler"]
cluster_authentication_mode = "API_AND_CONFIG_MAP"
cluster_admin_permission = true
node_group_name = "eks_terraform_prod_managed_nodes"
node_group_ami_type = "AL2023_x86_64_STANDARD"
node_group_disk_size = 20
node_group_size = 1
node_group_size = 2
node_group_desired_size = 1
node_group_instances_type = ["t2.medium"]
node_group_capacity_type = "ON_DEMAND"
service_ipv4_cidr = "172.16.0.0/12"
ec2_ssh_key = "mac_key_new.pem"
cluster_public_access_cidrs = ["0.0.0.0/0"] # Also we can use multiple cider range ["10.0.0.0/24", "172.0.0.0/16"]


          
