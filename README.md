![image](https://github.com/user-attachments/assets/10a22226-d628-4236-bc18-f5daec7459f5)
<h1> Automating the EKS cluster creation using Jenkins and Terraform</h1>

In today's fast-paced DevOps environment, automation is the key to efficiency and reliability. Creating and managing Kubernetes clusters, such as Amazon EKS (Elastic Kubernetes Service), can be a complex and time-consuming task if done manually. By leveraging Jenkins and Terraform, you can automate the entire process of EKS cluster creation, ensuring consistency, reducing human error, and saving valuable time. streamlining your EKS cluster creation process to mere clicks or commands instead of hours spent on manual configurations.

we’ll see the seamless integration of Jenkins and Terraform to automate the EKS cluster setup—from initial configuration to deployment—empowering.

<h2>Pre-requistes</h2>

**Jenkins Installation** -  Setup a Jenkins server by installing Jenkins on EC2 instance.  

**Terraform Installation** - Install Terraform on the Jenkins server.

**AWS CLI Installation** - Install the AWS Command Line Interface (CLI) and configure it with your AWS credentials (or) Attach the IAM role on Jenkins server to access the aws cloud

## Terraform Configuration File:

**main.tf**
```hcl
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
```

**variable.tf**
```hcl
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
```
VPC and EKS sub-module files are in modules directory

## Configure a pipeline Job:

* Create a pipeline and add the github repository url, credentails and branch

<img width="794" alt="Screenshot 2024-08-09 at 3 59 51 PM" src="https://github.com/user-attachments/assets/f9d01232-cd49-432c-8ea6-5d9ca6289c7f">
<img width="806" alt="Screenshot 2024-08-09 at 4 00 13 PM" src="https://github.com/user-attachments/assets/26688a97-620b-4f45-9f78-e75839804027">


* configure a github webhook to trigger a jenkins pipeline job automatically when changes are pushed to the GitHub repository.
  

   <img width="862" alt="Screenshot 2024-08-09 at 4 00 26 PM" src="https://github.com/user-attachments/assets/e7ad9836-dd09-4e28-9813-522e0e6d5e10">


## Jenkinsfile

```groovy
pipeline {
    agent any

    stages {
        stage('terraform initialization') {
            steps {
            withCredentials([gitUsernamePassword(credentialsId: 'git_cred', gitToolName: 'Default')]) {
                sh 'terraform init'
            }  
          }
        }    
        stage('terraform plan') {
            steps {
                sh 'terraform plan -var-file="vpc_ec2.tfvars"'
            }
        }
        stage('terraform deploy') {
            steps {
                sh 'terraform destroy -var-file="vpc_ec2.tfvars" -auto-approve'
            }
        }
    }
}
```

* Now whenever we make changes and commit a script it will trigger a webhook and jenkins job trigger automatically.

* Ensure that the build executed successfully and check the console
   
<img width="1052" alt="Screenshot 2024-08-09 at 4 04 49 PM" src="https://github.com/user-attachments/assets/753589ec-a45e-4355-a9b1-f40002774ced">



