resource "tls_private_key" "instance_sshkeys" {
  algorithm = "${var.KEY_ALGORITHM}"
  rsa_bits  = "${var.KEY_BITS}"
}

resource "aws_ssm_parameter" "instance_private_key" {
  name        = "/key/${var.stage}/privatekey"
  description = "demo instance Private Key"
  type        = "SecureString"
  value       = "${tls_private_key.instance_sshkeys.private_key_pem}"
  overwrite   = "${var.sshkey_overwrite}"
  depends_on  = ["tls_private_key.instance_sshkeys"]
}

resource "aws_ssm_parameter" "instance_public_key" {
  name        = "/key/${var.stage}/publickey"
  description = "secretstore Public Key"
  type        = "String"
  value       = "${tls_private_key.instance_sshkeys.public_key_openssh}"
  overwrite   = "${var.sshkey_overwrite}"
  depends_on  = ["tls_private_key.instance_sshkeys"]
}

resource "aws_key_pair" "auth" {
  key_name   = "demo-keypair-${var.stage}"
  public_key = tls_private_key.instance_sshkeys.public_key_openssh
}


resource "aws_instance" "demo_instance" {
  count             = var.instance_count
  ami               = "${data.aws_ami.amazon_linux_image.id}"
  instance_type     = var.instance_type
  subnet_id         = "${element(module.vpc.public_subnets, count.index)}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  # iam_instance_profile = "${var.s3_snapshot_instance_profile}"

  vpc_security_group_ids = [
    "${module.vpc.default_security_group_id}"
  ]
  timeouts {
    create = "40m"
    update = "40m"
    delete = "50m"
  }
  key_name = "demo-keypair-${var.stage}"
}
