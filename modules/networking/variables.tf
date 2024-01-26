variable "region" {
  description = "AWS Deployment region."
  default = "us-west-1"
}

variable "environment" {
  description = "Prod|Dev"
  default = "dev"
}

variable "vpc_cidr" {
  description = "Cidr for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  description = "pub subnet Cidr "
  default = ["10.0.1.0/24"]
}

variable "private_subnets_cidr" {
  description = "priv subnet Cidr "
  default = ["10.0.2.0/24"]
}

