

resource "aws_security_group" "secgroup_instance" {
  name = "sg.demo.${var.stage}"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
    description = " Allow public internet facing traffic on port 443"
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
    description = " Allow public internet facing traffic on port 80"
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
    description = "Allow public internet facing traffic on port 22"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

}

resource "aws_security_group" "secgroup_db" {
  name = "sg.demo.db.${var.stage}"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [aws_security_group.secgroup_instance.id]
    description = " Allow public internet facing traffic on port 443"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

}

# resource "aws_security_group" "secgroup_esearch_kibana" {
#   name = "sg.${var.org_scope}.${var.functional_scope}.${var.module_name}.esearch_kibana.${var.stage}"
#   vpc_id = "${var.vpc_id}"

#   ingress {
#     from_port = 80
#     to_port = 80
#     protocol = "tcp"
#     cidr_blocks = [
#       "0.0.0.0/0"]
#     description = ""
#   }
#   ingress {
#     from_port = 80
#     to_port = 80
#     protocol = "tcp"
#     ipv6_cidr_blocks = [
#       "::/0"]
#     description = "IPV6"
#   }
#   ingress {
#     from_port = 80
#     to_port = 80
#     protocol = "tcp"
#     self = true
#     description = "Load Balancer HTTP"
#   }
#   ingress {
#     from_port = 443
#     to_port = 443
#     protocol = "tcp"
#     cidr_blocks = [
#       "0.0.0.0/0"]
#     description = ""
#   }
#   ingress {
#     from_port = 443
#     to_port = 443
#     protocol = "tcp"
#     ipv6_cidr_blocks = [
#       "::/0"]
#     description = ""
#   }
#   ingress {
#     from_port = 443
#     to_port = 443
#     protocol = "tcp"
#     self = true
#     description = "Load Balance HTTP"
#   }
#   ingress {
#     from_port = 9343
#     to_port = 9343
#     protocol = "tcp"
#     self = true
#     description = "Elasticsearch (transport client/transport client with TLS/SSL), also required by load balancers"
#   }

#   ingress {
#     from_port = 9243
#     to_port = 9243
#     protocol = "tcp"
#     self = true
#     description = "Allow Elastic access only SSH"
#   }

#   egress {
#     from_port = 9243
#     to_port = 9243
#     protocol = "tcp"
#     cidr_blocks = [
#       "${var.vpc_cidr}"]
#     description = "Kibana and Elastic https traffic"
#   }

#   egress {
#     from_port = 9200
#     to_port = 9200
#     protocol = "tcp"
#     cidr_blocks = [
#       "${var.vpc_cidr}"]
#     description = "Kibana and Elastic http traffic"
#   }

#   egress {
#     from_port = 443
#     to_port = 443
#     protocol = "tcp"
#     cidr_blocks = [
#       "0.0.0.0/0"]
#     description = "Allow this port for Lambda functions to connect to Vault over https and AWS SES API"
#   }
#   tags = "${merge(
#       var.common_tags,
#       map(
#         "Name", "sg.${var.org_scope}.${var.functional_scope}.${var.module_name}.esearch_kibana.${var.stage}"
#       )
#     )}"
# }