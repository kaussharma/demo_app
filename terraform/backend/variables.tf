variable "region" {
  description = "Target AWS region to deploy to"
  type        = "string"
}

variable "bucket" {
  description = "AWS S3 bucket folder to store Terraform state"
  type        = "string"
}

variable "dynamodb_table" {
  description = "AWS DynamoDB lock"
  type        = "string"
}
