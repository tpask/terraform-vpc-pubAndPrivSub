variable "region" {
  description = "AWS Deployment region."
  default = "us-west-2"
}

variable "environment" {
  description = "Prod|Dev"
  default = "dev"
}

variable "vpc_cidr" {
  description = "Cidr for the VPC"
  default = ""
}

variable "public_subnets_cidr" {
  description = "pub subnet Cidr "
  default = []
}

variable "private_subnets_cidr" {
  description = "priv subnet Cidr "
  default = []
}

variable nameHeader {
  default = "notSet"
}


