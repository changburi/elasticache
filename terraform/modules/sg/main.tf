resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "open ssh port for bastion"

  vpc_id = "${var.vpc_id}"

//  ingress {
//    from_port   = 22
//    to_port     = 22
//    protocol    = "tcp"
//    cidr_blocks = ["0.0.0.0/0"]
//  }
//
//  egress {
//    from_port   = 00
//    to_port     = 0
//    protocol    = "-1"
//    cidr_blocks = ["0.0.0.0/0"]
//  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  tags = {
    Name = "bastion"
  }
}

data aws_vpc "default" {
  default = true
}

resource "aws_default_security_group" "dev_default" {
  vpc_id = "${var.vpc_id}"
//  vpc_id = "${data.aws_vpc.default.id}"

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev-default"
  }
}

//resource "aws_security_group" "ssh" {
//  name = "allow_ssh_from_all"
//  description = "Allow SSH port from all"
//  ingress {
//    from_port = 22
//    to_port = 22
//    protocol = "tcp"
//    cidr_blocks = ["0.0.0.0/0"]
//  }
//}
//resource "aws_security_group" "default" {
//  count       = var.enabled && var.vpc_enabled ? 1 : 0
//  vpc_id      = var.vpc_id
//  name        = "terraform elasticsearch example"
//  description = "Allow inbound traffic from Security Groups and CIDRs. Allow all outbound traffic"
//  tags        = "terraform elasticsearch example"
//}
////data "aws_security_group" "default" {
////  name = "default"
////}
//resource "aws_security_group" "instance" {
//  name = "terraform-example-iam-instance"
//  ingress {
//    from_port   = var.server_port
//    to_port     = var.server_port
//    protocol    = "tcp"
//    cidr_blocks = ["210.94.41.89/32"]
//  }
//  lifecycle {
//    create_before_destroy = true
//  }
//  tags = {
//    Name = "sg.iam.onwer:cjub.oh"
//  }
//}