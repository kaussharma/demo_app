resource "random_password" "db_password" {
  length           = 16
  special          = false
  override_special = "/@\" "
}

module "db" {
  source                              = "terraform-aws-modules/rds/aws"
  version                             = "~> 2.0"
  identifier                          = "demo-db-${var.stage}"
  engine                              = "postgres"
  engine_version                      = "9.6.9"
  instance_class                      = "db.t2.micro"
  allocated_storage                   = 20
  storage_encrypted                   = "false"
  name                                = "demo_db"
  username                            = "demo"
  password                            = "${random_password.db_password.result}"
  port                                = "5432"
  iam_database_authentication_enabled = true
  #multi_az = "true"
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
  subnet_ids           = "${module.vpc.database_subnets}"
  family               = "postgres9.6"
  major_engine_version = "9.6"
  deletion_protection  = false
  publicly_accessible  = "true"
  backup_window        = ""
  maintenance_window   = ""
}

resource "aws_ssm_parameter" "private_key" {
  name        = "/${var.stage}/db_password"
  description = "demo database password for stage ${var.stage}"
  type        = "SecureString"
  value       = "${random_password.db_password.result}"
  overwrite   = true
  depends_on  = ["random_password.db_password"]
}