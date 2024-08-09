##############################
# VPC related variables
##############################
variable "cidr_block" { }

variable "aws_region" { }

variable "enable_dns_hostnames" {
  type = bool
}

variable "enable_dns_support" {
  type = bool
}

variable "public_subnet_cidr" {
  type = list(string)
}

variable "private_subnet_cidr" {
  type = list(string)
}

variable "availability_zone" {
  type = list(string)
}

variable "enable_nat_gateway" {
type = bool
}

#######################################
# EKS releated variables
#######################################

#variable "public_subnet_ids" { }
variable "cluster_endpoint_private_access" { }
variable "cluster_endpoint_public_access" { }
variable "cluster_authentication_mode" { }
variable "cluster_name" { }
variable "node_group_min_size" { }
variable "node_group_max_size" { }
variable "node_group_desired_size" { }
variable "node_group_instances_type" { }
variable "cluster_version" { }
variable "service_ipv4_cidr" { }
variable "cluster_admin_permission" { }
variable "cluster_enabled_cluster_log_types" { }
variable "ec2_ssh_key" { }
variable "node_group_capacity_type" { }
variable "node_group_ami_type" { }
variable "node_group_disk_size" { } 
variable "node_group_name" { }
variable "cluster_public_access_cidrs" { }
