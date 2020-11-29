//data "aws_vpc" "default" {
//  default = true
//}
//data "aws_subnet_ids" "all" {
//  vpc_id = data.aws_vpc.default.id
//}
//data "aws_security_group" "default" {
//  vpc_id = data.aws_vpc.default.id
//  name = "default"
//}
// aws vpc
resource "aws_vpc" "vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "vpc-dev"
  }

}

// aws elastic ip
resource "aws_eip" "nat_dev_2a" {
  vpc = true
}
resource "aws_eip" "nat_dev_2c" {
  vpc = true
}

// aws internet gateway
resource "aws_internet_gateway" "dev" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "dev"
  }
}
resource "aws_nat_gateway" "dev_2a" {
  allocation_id = "${aws_eip.nat_dev_2a.id}"
  subnet_id     = "${aws_subnet.public_2a.id}"
}

// aws gateway
resource "aws_nat_gateway" "dev_2c" {
  allocation_id = "${aws_eip.nat_dev_2c.id}"
  subnet_id     = "${aws_subnet.public_2c.id}"
}

// aws nacl
resource "aws_default_network_acl" "dev_default" {
  default_network_acl_id = "${aws_vpc.vpc.default_network_acl_id}"

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  subnet_ids = [
    "${aws_subnet.public_2a.id}",
    "${aws_subnet.public_2c.id}",
    "${aws_subnet.private_2a.id}",
    "${aws_subnet.private_2c.id}",
  ]

  tags = {
    Name = "dev-default"
  }
}
// aws subnet
resource "aws_subnet" "public_2a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "ap-northeast-2a"
  cidr_block        = "172.16.1.0/24"

  tags = {
    Name = "public-2a"
  }
}
resource "aws_subnet" "private_2a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "ap-northeast-2a"
  cidr_block        = "172.16.101.0/24"

  tags = {
    Name = "private-2a"
  }
}
resource "aws_subnet" "public_2c" {
  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "ap-northeast-2c"
  cidr_block        = "172.16.2.0/24"

  tags = {
    Name = "public-2c"
  }
}
resource "aws_subnet" "private_2c" {
  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "ap-northeast-2c"
  cidr_block        = "172.16.102.0/24"

  tags = {
    Name = "private-2c"
  }
}



// aws route table
# dev_public
resource "aws_route_table" "dev_public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.dev.id}"
  }

  tags = {
    Name = "dev-public"
  }
}
resource "aws_route_table_association" "dev_public_2a" {
  subnet_id      = "${aws_subnet.public_2a.id}"
  route_table_id = "${aws_route_table.dev_public.id}"
}
resource "aws_route_table_association" "dev_public_2c" {
  subnet_id      = "${aws_subnet.public_2c.id}"
  route_table_id = "${aws_route_table.dev_public.id}"
}
# dev_private_1a
resource "aws_route_table" "dev_private_2a" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.dev_2a.id}"
  }

  tags = {
    Name = "dev-private-1a"
  }
}
resource "aws_route_table_association" "dev_private_2a" {
  subnet_id      = "${aws_subnet.private_2a.id}"
  route_table_id = "${aws_route_table.dev_private_2a.id}"
}
# dev_private_1c
resource "aws_route_table" "dev_private_2c" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.dev_2c.id}"
  }

  tags = {
    Name = "dev-private-2c"
  }
}
resource "aws_route_table_association" "dev_private_2c" {
  subnet_id      = "${aws_subnet.private_2c.id}"
  route_table_id = "${aws_route_table.dev_private_2c.id}"
}

