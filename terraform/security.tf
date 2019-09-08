

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
    description = " Allow DB access from ec2 instance"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

}
