variable "cluster_name" { }
variable "public_subnet_id" { }
variable "cluster_endpoint_private_access" { }
variable "cluster_endpoint_public_access" { }
variable "cluster_authentication_mode" { }
variable "node_group_min_size" { }
variable "node_group_max_size" { }
variable "node_group_desired_size" { }
variable "node_group_instances_type" { }
variable "service_ipv4_cidr" { }
variable "cluster_version" { }
variable "cluster_admin_permission" { }
variable "cluster_enabled_cluster_log_types" { type = list(string)}
variable "cluster_public_access_cidrs" { }
variable "ec2_ssh_key" { }
variable "node_group_capacity_type" { }
variable "node_group_ami_type" { }
variable "node_group_disk_size" { } 
variable "node_group_name" { }
variable "vpc_id" { }



