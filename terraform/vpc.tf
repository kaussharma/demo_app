module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  name                   = "my-vpc-${var.stage}"
  cidr                   = "10.0.0.0/24"
  create_vpc             = "true"
  azs                    = ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}", "${data.aws_availability_zones.available.names[2]}"]
  public_subnets         = ["${cidrsubnet(module.vpc.vpc_cidr_block, 3, 0)}"]
  database_subnets       = ["${cidrsubnet(module.vpc.vpc_cidr_block, 3, 1)}", "${cidrsubnet(module.vpc.vpc_cidr_block, 3, 2)}", "${cidrsubnet(module.vpc.vpc_cidr_block, 3, 3)}"]
  enable_dns_hostnames   = true
  enable_dns_support     = true
  tags = {
    Terraform   = "true"
    Environment = "${var.stage}"
  }
}

