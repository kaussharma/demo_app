stage = "dev"

instance_type  = "t2.micro"
instance_count = 1

KEY_BITS      = 4096
KEY_ALGORITHM = "RSA"

ssm_path = "/demo/"

DESTINATION_SSH_KEY_PRIVATE = "../ansible/.ssh/ssh_private_key"
DESTINATION_SSH_KEY_PUBLIC  = "../ansible/.ssh/ssh_private_key.pub"

sshkey_overwrite = "true"
