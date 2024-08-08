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
/*
module "ec2" {cd ..

  #region = var.aws_region
  #for_each = [ for sub in module.vpc.aws_subnet_id : sub.id ]
  #count = length(module.vpc.aws_subnet_id)
  #count = var.aws_instance_count
  aws_instance_type = var.aws_instance_type
  root_block_device_size = var.root_block_device_size
  root_block_device_type = var.root_block_device_type
  aws_instance_count = var.aws_instance_count
  #vpc_id = module.vpc.aws_vpc_id
  #subnet_id = element(tolist(module.vpc.aws_subnet_id), count.index)
  #subnet_ids = module.vpc.public_subnet_id[count.index]
  #public_subnet_id = element(module.vpc.public_subnet_id, count.index)
  public_subnet_id = module.vpc.public_subnet_id
  #module.vpc.aws_subnet.terraform_prod[2]

  depends_on = [module.vpc]
}
*/
# cluster creation took 8 min and node group took 2 min
module "eks" {
  source = "/workspaces/terraform-modules/workspace/modules/eks"
  
  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  public_subnet_id = module.vpc.public_subnet_id
  endpoint_private_access= var.endpoint_private_access
  endpoint_public_access = var.endpoint_public_access
  cluster_public_access_cidrs = var.cluster_public_access_cidrs
  cluster_authentication_mode = var.cluster_authentication_mode
  cluster_admin_permission = var.cluster_admin_permission
  enabled_cluster_log_types = var.enabled_cluster_log_types
  service_ipv4_cidr = var.service_ipv4_cidr


  node_ami_type = var.node_ami_type
  capacity_type = var.capacity_type
  node_disk_size = var.node_disk_size
  eks_instances_type = var.eks_instances_type
  node_group_name = var.node_group_name
  ec2_ssh_key = var.ec2_ssh_key
  node_min_size = var.node_min_size
  node_max_size = var.node_max_size
  node_desired_size = var.node_desired_size
  vpc_id = module.vpc.aws_vpc_id

  depends_on = [ module.vpc ]

}

/*
pipeline {
    agent any
    
    tools {
        maven 'maven3'
        //Docker 'docker'// This should match the name of the Maven tool in the Global Tool Configuration
    }

    stages {
        stage('git checkout') {
            steps {
                git credentialsId: 'cred', url: 'https://github.com/senthilcsk24/shopping_cart.git'
            }
        }
        stage('maven build') {
            steps {
                sh 'mvn package install -Dmaven.test.skip=true' 
            }
        }
        stage('docker build') {
            steps {
                sh 'docker build -f docker/Dockerfile -t shopping_docker .' 
            }
        }
        stage('docker image scan') {
            steps {
                sh 'trivy -f table -o scan_report.txt image shopping_docker:latest' 
            }
        }
        stage('Login to ecr registry and docker push') {
            steps {
                script{
                    withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'ecr_cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
    // some block
                   sh ' aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 975049977826.dkr.ecr.us-east-1.amazonaws.com'
                   sh ' docker tag shopping_docker:latest 975049977826.dkr.ecr.us-east-1.amazonaws.com/shopping_docker:${BUILD_NUMBER}'
                   sh ' docker push 975049977826.dkr.ecr.us-east-1.amazonaws.com/shopping_docker:${BUILD_NUMBER}'
                    }
                }
            }
        }
    }
}
*/