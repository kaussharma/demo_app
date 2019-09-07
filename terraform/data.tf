data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}


data "aws_ami" "amazon_linux_image" {
  most_recent = true
  owners      = ["amazon"]
  name_regex  = "Amazon Linux 2*"



}
