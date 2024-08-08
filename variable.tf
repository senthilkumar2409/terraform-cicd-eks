##############################
# VPC
##############################
variable "cidr_block" {
}

variable "aws_region" {
}

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

##############################
# EC2
##############################
variable "aws_instance_type" {
  type = string
}

variable "root_block_device_size" {
  type = string
}

variable "root_block_device_type" {
  type = string
}

variable "aws_instance_count" {
  type = number
}

#variable "public_subnet_id" {
 # type = list(string)
#}
#variable "subnet_ids" {
 #type = list(string)
#}

#variable "vpc_id" {
 # type = string
#}

#######################################
# EKS
#######################################

#variable "public_subnet_ids" { }
variable "endpoint_private_access" { }
variable "endpoint_public_access" { }
variable "cluster_authentication_mode" { }
variable "cluster_name" { }
variable "node_min_size" { }
variable "node_max_size" { }
variable "node_desired_size" { }
variable "eks_instances_type" { }
variable "cluster_version" { }
variable "service_ipv4_cidr" { }
variable "cluster_admin_permission" { }
variable "enabled_cluster_log_types" { }
variable "ec2_ssh_key" { }
variable "capacity_type" { }
variable "node_ami_type" { }
variable "node_disk_size" { } 
variable "node_group_name" { }
variable "cluster_public_access_cidrs" { }