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
  type = "string"
}