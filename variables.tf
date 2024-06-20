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
  default = "10.2.0.0/16"
}

variable "public_subnets_cidr" {
  description = "pub subnet Cidr "
  default = "10.2.1.0/24"
}

variable "private_subnets_cidr" {
  description = "priv subnet Cidr "
  default = "10.2.2.0/24"
}

variable "owner" { default = "tp" }

variable "instance_type" { default = "t3.micro" }
variable "volume_size" { default = "25" }
variable "project" { default = "oval" }
variable "pubkey_file" { default = "~/.ssh/id_ed25519.pub"}
#variable "AMIS" { type = map(string) }

data "http" "my_ip" { url = "http://checkip.amazonaws.com/"}

# get the latest amazon-linux-2-ami
data "aws_ami" "al2" {
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

data "aws_ami" "al2023" {
  most_recent      = true
  owners           = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  } 
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "centos7" {
  most_recent = true
  filter {
    name   = "name"
    values = ["CentOS 7*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["679593333241"]  # CentOS official AWS account ID
}


#define userdata to execute right after boot
locals {
  instance-userdata = <<EOF
  #!/bin/bash
  yum -y update
EOF
  common_tags = {
    Name        = "oval"
    Environment = "dev"
    owner = "tp"
    Create_date_time = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
  }
  AMIS = {
    #al2       = data.aws_ami.al2.id #"ami-0ca285d4c2cda3300"
    al2023   = data.aws_ami.al2023.id # "ami-0eb9d67c52f5c80e5"
    centos7  = "ami-08c191625cfb7ee61" # subscribe: https://aws.amazon.com/marketplace/server/procurement?productId=d9a3032a-921c-4c6d-b150-bde168105e42
    #centos8  = "ami-031e6a417aae9b9f6" # streams - subscribe: https://aws.amazon.com/marketplace/server/procurement?productId=a5911e94-1971-4697-9bc5-02904340f1df
    #centos9   = "ami-094cc0ced7b91fcf0" #9stream us-west-2
  }
}

