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
  default = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  description = "pub subnet Cidr "
  default = "10.0.1.0/24"
}
variable "private_subnets_cidr" {
  description = "priv subnet Cidr "
  default = "10.0.2.0/24"
}

variable "owner" { default = "terraform" }
variable "instance_type" { default = "t3.micro" }
variable "volume_size" { default = "25" }
variable "subnet_id" { default = "" }
variable "vpc_id" { default = "" }
variable "AMIS" { type = map(string) }
variable "project" { default = "notSet" }
variable "tags" {
   default = {
     Environment = "dev"
   }
}



variable "pubkey_file" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}

variable "other_sg_ids" { default = ""}

#define userdata to execute right after boot
locals {
  instance-userdata = <<EOF
  #!/bin/bash
  yum -y update
EOF
}

# get the latest amazon-linux-2-ami
data "aws_ami" "amz_linux" {
  most_recent = true
  owners      = ["137112412989"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}