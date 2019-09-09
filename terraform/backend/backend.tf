resource "aws_s3_bucket" "tfstate" {
  bucket = "${var.bucket}"
  acl    = "private"

  region = "${var.region}"

  versioning {
    enabled = true
  }

  force_destroy = true
}

resource "aws_dynamodb_table" "tfstate_lock" {
  name           = "${var.dynamodb_table}"
  hash_key       = "LockID"
  read_capacity  = 10
  write_capacity = 10

  attribute {
    name = "LockID"
    type = "S"
  }
}
