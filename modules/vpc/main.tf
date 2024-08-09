#####################################
#VPC
#####################################

resource "aws_vpc" "kube_vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  tags = {
    Name = "terraform_vpc"
    "kubernetes.io/cluster/eks_kube_vpc" = "owned"
  } 
}

#####################################
#SUBNET
#####################################

resource "aws_subnet" "kube_public_subnet" {
  count = 3 # creates a three subnet in each availability zones as per the input given in variable block
  vpc_id = aws_vpc.kube_vpc.id
  map_public_ip_on_launch = true
  availability_zone = element(var.availability_zone, count.index) #data.aws_availability_zone.available.name[0] 
  cidr_block = element(var.public_subnet_cidr, count.index)
  tags = {
    Name = "terraform_public_subnet-${count.index}"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "kube_private_subnet" {
  count = var.enable_nat_gateway ? 3 : 0 # creates a three subnet in each availability zones as per the input given in variable block
  vpc_id = aws_vpc.kube_vpc.id
  map_public_ip_on_launch = true
  availability_zone = element(var.availability_zone, count.index) #data.aws_availability_zone.available.name[0] 
  cidr_block = element(var.private_subnet_cidr, count.index)
  tags = {
    Name = "terraform_private_subnet-${count.index}"
  }
}
#####################################
#INTERNET GATEWAY
#####################################

resource "aws_internet_gateway" "kube_internet_gateway" {
  vpc_id = aws_vpc.kube_vpc.id
  tags = {
    Name = "terraform_ig"
  }
}

resource "aws_internet_gateway_attachment" "kube_internet_gateway_attach" {
  internet_gateway_id = aws_internet_gateway.kube_internet_gateway.id
  vpc_id = aws_vpc.kube_vpc.id
}

resource "aws_nat_gateway" "kube_nat_gateway" {
  count = var.enable_nat_gateway ? 1 : 0 # ternary operator / condition 
  subnet_id = aws_subnet.kube_public_subnet[0].id
  tags = {
    Name = "terraform_prod_nat_gateway"
  }
  depends_on = [ aws_internet_gateway.kube_internet_gateway ]
  }

######################################
#ROUTE TABLE
######################################
# Public route table
resource "aws_route_table" "kube_public_route_table" {
  vpc_id = aws_vpc.terraform_prod.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kube_internet_gateway.id
  }
  tags = {
    Name = "terraform_prod_route_table_public"
  } 
}

resource "aws_route_table_association" "kube_public_route_table_assign" {
  count = 3
  route_table_id = aws_route_table.kube_public_route_table.id
  subnet_id = aws_subnet.kube_public_subnet[count.index].id
}

# Private route table
resource "aws_route_table" "kube_private_route_table" {
  count = var.enable_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.kube_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.kube_nat_gateway[count.index].id
  }
  tags = {
    Name = "terraform_prod_route_table_private"
  } 
  depends_on = [ aws_nat_gateway.kube_nat_gateway ]
}

resource "aws_route_table_association" "private_route_table_assign" {
  count = var.enable_nat_gateway ? 3 : 0
  route_table_id = aws_route_table.private_route_table[count.index].id
  subnet_id = aws_subnet.kube_private_subnet[count.index].id
}
#######################################
#SECURITY GROUP
#######################################

resource "aws_security_group" "kube_security_group" {
  vpc_id = aws_vpc.kube_vpc.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"] # source cidr/IP range
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = -1
  }
  tags = {
    Name = "terraform_prod"
  } 
}
