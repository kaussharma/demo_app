resource "tls_private_key" "instance_sshkeys" {
  algorithm = "${var.KEY_ALGORITHM}"
  rsa_bits  = "${var.KEY_BITS}"
}

resource "aws_ssm_parameter" "instance_private_key" {
  name        = "/${var.stage}/privatekey"
  description = "demo instance Private Key"
  type        = "SecureString"
  value       = "${tls_private_key.instance_sshkeys.private_key_pem}"
  overwrite   = "${var.sshkey_overwrite}"
  depends_on  = ["tls_private_key.instance_sshkeys"]
}

resource "aws_ssm_parameter" "instance_public_key" {
  name        = "/${var.ssm_path}/publickey"
  description = "secretstore Public Key"
  type        = "String"
  value       = "${tls_private_key.instance_sshkeys.public_key_openssh}"
  overwrite   = "${var.sshkey_overwrite}"
  depends_on  = ["tls_private_key.instance_sshkeys"]
}


/*
resource "aws_instance" "ece_instance" {
  count = "1"
  ami = "${var.ece_vw_ami_id}"
  instance_type = "t2.micro"
  subnet_id = "${module.vpc.public_subnets}"
  availability_zone = "${module.vpc.azs}"
 # iam_instance_profile = "${var.s3_snapshot_instance_profile}"

  vpc_security_group_ids = [
    "${module.vpc.default_vpc_default_security_group_id}"
  ]
  timeouts {
    create = "40m"
    update = "40m"
    delete = "50m"
  }
  key_name = "${aws_key_pair.auth.key_name}"
}*/
