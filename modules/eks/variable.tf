variable "cluster_name" { }
variable "public_subnet_id" { }
variable "endpoint_private_access" { }
variable "endpoint_public_access" { }
variable "cluster_authentication_mode" { }
variable "node_min_size" { }
variable "node_max_size" { }
variable "node_desired_size" { }
variable "eks_instances_type" { }
variable "service_ipv4_cidr" { }
variable "cluster_version" { }
variable "cluster_admin_permission" { }
variable "enabled_cluster_log_types" { type = list(string)}
variable "cluster_public_access_cidrs" { }
variable "ec2_ssh_key" { }
variable "capacity_type" { }
variable "node_ami_type" { }
variable "node_disk_size" { } 
variable "node_group_name" { }
variable "vpc_id" { }



