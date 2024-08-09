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

variable "public_subnet_cidr" {
  default = ["10.0.0.0/24","10.0.1.0/24","10.0.2.0/24"]
  type = list(string)
}

variable "public_subnet_id" {
  type = list(string)
}

#variable "vpc_id" {
 # type = string
#}