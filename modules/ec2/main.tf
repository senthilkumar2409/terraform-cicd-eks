
data "aws_ami" "amzn3" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = [ "al2023-ami-*-kernel-*-x86_64" ] #al2023-ami-*-kernel-*-x86_64
  } 
  #AL2023_x86_64_STANDARD
  /* 
  filter {
    name = "Virtualization"
    values = ["hvm"]
  }
  */
  /*
  filter {
    name = "Root device type"
    values = ["ebs"]
  }
  */
  /*  
  filter {
    name = "Architecture"
    values = ["x86_64"]
  }
  */
}

data "aws_key_pair" "terraform_prod" {
  key_name    = "mac_key_new.pem"
  #key_pair_id = "key-0dbef89963e24c292"
}

resource "aws_instance" "terraform_prod" {
  #for_each = [ for prod in module.vpc.aws_subnet_id : prod.id ]
  #count = length(module.vpc.aws_subnet_id)
  #count = length(var.public_subnet_id)
  count = var.aws_instance_count
  ami = data.aws_ami.amzn3.id
  instance_type = var.aws_instance_type
  #subnet_id = element(tolist(module.vpc.aws_subnet_id), count.index) #element(var.public_subnet_cidr, count.index)
  #subnet_id = var.public_subnet_id
  subnet_id = element(var.public_subnet_id, count.index)
  key_name = data.aws_key_pair.terraform_prod.key_name

  tags = {
      Name = "terraform_prod_INC-${count.index}"
    }
  root_block_device {
    volume_size = var.root_block_device_size
    volume_type = var.root_block_device_type
    tags = {
      Name = "terraform_prod_root"
    }
  }
}



