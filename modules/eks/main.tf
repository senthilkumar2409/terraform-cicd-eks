#########################################################
# Creation of IAM Role for eks node group (just Iam role)
#########################################################

resource "aws_iam_role" "eks_nodegroup_role" {
  name = "eks-node-group-roles-terraform-prod"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

#########################################################
# Policy attachement with the IAM role for eks node group
#########################################################

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
 role = aws_iam_role.eks_nodegroup_role.name
 }

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy" 
   role = aws_iam_role.eks_nodegroup_role.name
 }

 resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
   role = aws_iam_role.eks_nodegroup_role.name
 }

#########################################################
# Creation of IAM Role for eks cluster (just Iam role)
#########################################################

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks_cluster_role_terraform_prod"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

#########################################################
# Policy attachement with the IAM role for eks cluster
#########################################################

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role = aws_iam_role.eks_cluster_role.name 
}

################################################################################
# EKS cluster 
################################################################################

 resource "aws_eks_cluster" "kube_cluster" {
   name = var.cluster_name
   role_arn = aws_iam_role.eks_cluster_role.arn
   version = var.cluster_version
   enabled_cluster_log_types = var.cluster_enabled_cluster_log_types

   vpc_config {
     endpoint_private_access = var.cluster_endpoint_private_access
     endpoint_public_access = var.cluster_endpoint_public_access
     public_access_cidrs = var.cluster_public_access_cidrs
     subnet_ids = var.public_subnet_id
   }
   kubernetes_network_config { #Kubernetes assigns IP addresses for services and pods in a cluster
     service_ipv4_cidr = var.service_ipv4_cidr
   }
   access_config {
     authentication_mode = var.cluster_authentication_mode
     bootstrap_cluster_creator_admin_permissions = var.cluster_admin_permission
   }  
   encryption_config {
    provider {
      key_arn = aws_kms_key.kms_encryption_cluster.arn
    }
    resources = [ "secrets" ]
   }
   
   depends_on = [ 
      aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
      aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    ]

 }

 resource "aws_eks_node_group" "public_node_group" {
   cluster_name = aws_eks_cluster.kube_cluster.name
   node_role_arn = aws_iam_role.eks_nodegroup_role.arn
   subnet_ids = var.public_subnet_id
   ami_type = var.node_group_ami_type
   capacity_type = var.node_group_capacity_type
   disk_size = var.node_group_disk_size
   instance_types = var.node_group_instances_type
   node_group_name = var.node_group_name

   remote_access {
     ec2_ssh_key = var.ec2_ssh_key
   }
   scaling_config {
     desired_size = var.node_group_desired_size
     min_size = var.node_group_min_size
     max_size = var.node_group_max_size
   }

   depends_on = [ 
      aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
      aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
      aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
      aws_eks_cluster.kube_cluster,
    ]
 }

################################################################
# IAM policy for developer to access a EKS cluster
################################################################
resource "aws_iam_policy" "developer_access_policy" {
  name = "developer_access_policy"
  policy = <<POLICY
  {
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": [
				"eks:DescribeCluster",
				"eks:ListClusters"
			],
			"Resource": "*"
		}
	]
}
POLICY
}

resource "aws_iam_group_policy_attachment" "developer" {
  group = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.developer_access_policy.arn
  depends_on = [ aws_iam_group.developers ]
}

#####################################################
# IAM group creation
#####################################################
resource "aws_iam_group" "developers" {
  name = "developers"
}

resource "aws_iam_user" "kube-developer" {
  name = "kube-developer"
}
#####################################################
# Adding user to kubernetes group
#####################################################
resource "aws_iam_group_membership" "addinguser" {
  name = "addinguser"
  users = ["kube-developer"]
  group = aws_iam_group.developers.name
  depends_on = [ aws_iam_group.developers, aws_iam_user.kube-developer ]
}

####################################################
# Access entry for developers group 
####################################################
resource "aws_eks_access_entry" "kube_cluster" {
  principal_arn = "arn:aws:iam::260657334892:user/kube-developer"
  cluster_name = aws_eks_cluster.kube_cluster.name
  kubernetes_groups = [ "developer" ] #It is the group name which we specify in a rolebinding.yaml manifest file
}

resource "aws_eks_access_policy_association" "kube_cluster" {
  cluster_name = aws_eks_cluster.kube_cluster.name
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = aws_iam_user.kube-developer.arn
  access_scope {
    type = "namespace"
    namespaces = [ "kube-system" ]
  }
  
}

resource "aws_kms_key" "kms_encryption_cluster" {
  
}

data "aws_eks_cluster_auth" "eks" {
  name = "eks_terraform_prod"
}
