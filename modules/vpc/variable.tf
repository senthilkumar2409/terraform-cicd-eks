variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
  default = true
  type = bool
}

variable "enable_dns_support" {
  default = true
  type = bool
}

variable "public_subnet_cidr" {
  type = list(string)
}

variable "private_subnet_cidr" {
  type = list(string)
}
variable "availability_zone" {
  default = ["us-east-1a","us-east-1b","us-east-1c"]
  type = list(string)
}

variable "enable_nat_gateway" {
type = bool
}

