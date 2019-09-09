variable "stage" {
}


variable "KEY_BITS" {
  type = "string"
}

variable "KEY_ALGORITHM" {
  type = "string"
}

variable "sshkey_overwrite" {
  type = "string"
}


variable "ssm_path" {
  description = "Permit access to SSM path for IAM Instance Profile"
  type        = "string"
}

variable "instance_type" {}
variable "instance_count" {}
variable "DESTINATION_SSH_KEY_PRIVATE" {}
variable "DESTINATION_SSH_KEY_PUBLIC" {}