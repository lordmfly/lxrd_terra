
module "networking" {
   source = "./modules/networking/"
   vpc_cidr = var.root_vpc_cidr
   env = var.env
   subnet_cidr1 = var.subnet_cidr1
   subnet_cidr2 = var.subnet_cidr2
   avail_zone1  = var.avail_zone1
   avail_zone2  = var.avail_zone2
}

module "ec2" {
  source = "./modules/ec2"
  vpc_id = module.networking.vpcId
  env = var.env
  key = var.key
  public = var.public
  instance_type = var.instance_type
  avail_zone1 = var.avail_zone1
  subnet_id = module.networking.subnetId
}
