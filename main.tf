module "networking" {
  source = "./modules/networking" 
  region               = var.region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  nameHeader           = "oval"
}

output "vpc_id" { value = "${module.networking.vpc_id}"}
output "public_subnet_id" { value = "${module.networking.public_subnet_id}"}
output "private_subnet_id" { value = "${module.networking.private_subnet_id}"}


module "publicEC2" {
  source = "./modules/ec2"
  project = var.project
  pubkey_file = var.pubkey_file
  vpc_id = module.networking.vpc_id
  subnet_id = module.networking.public_subnet_id
  ami = data.aws_ami.amz_linux.id
  nameHeader = "oval"
}


