data "aws_ami" "amzlinux2" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-*"]
  }
}
resource "aws_eip" "bastion_2a" {
  instance = "${aws_instance.bastion_2a.id}"
  vpc      = true
}
resource "aws_instance" "bastion_2a" {
  ami               = "${data.aws_ami.amzlinux2.id}"

//  ami               = "ami-05466daab6a2abe63"
  availability_zone = "ap-northeast-2a"
  instance_type     = "t2.micro"
//  key_name          = "${var.dev_keyname}"
//  key_name          = "${var.dev_keyname}"

  vpc_security_group_ids = [
    "${var.bastion.id}"
  ,"${var.dev_default.id}"
  ]
  subnet_id                   = "${var.public_2a_id}"
  associate_public_ip_address = true

  tags = {
    Name = "bastion-2a"
  }
}
//resource "aws_instance" "web" {
//  ami           = "${data.aws_ami.amzlinux2.id}"
//  instance_type = "t2.micro"
//  key_name = "${var.bastion_key_name}"
//  vpc_security_group_ids = [
//    var.ssh_id
//    //    data.aws_security_group.ssh.id
//  ]
//  tags = {
//    Name = "instance.iam.onwer:cjub.oh"
//  }
//}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
//  vpc_id = "${var.vpc_id}"
  ingress {
    from_port = var.server_port
    protocol = "tcp"
    to_port = var.server_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
//data "aws_ami" "amzlinux2" {
//  most_recent      = true
//  owners           = ["amazon"]
//
//  filter {
//    name   = "name"
//    values = ["amzn2-*"]
//  }
//}
resource "aws_launch_configuration" "example" {
//  image_id = "ami-05466daab6a2abe63"
  image_id = "${data.aws_ami.amzlinux2.id}"
  instance_type = var.instance_type
//  security_groups = [aws_security_group.instance.id]
  security_groups = ["${aws_security_group.instance.id}"]
//  vpc_classic_link_id = ""
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_availability_zones" "all" {}


//resource "aws_autoscaling_group" "example" {
//  launch_configuration = aws_launch_configuration.example.id
//  availability_zones = ["ap-northeast-2a","ap-northeast-2b","ap-northeast-2c", "ap-northeast-2d"]
////  availability_zones = [data.aws_availability_zones.all.names]
//
//  load_balancers = [aws_elb.example.name]
//  health_check_type = "ELB"
//
//  min_size = var.min_size
//  max_size = var.max_size
//
//  tag {
//    key = "Name"
//    propagate_at_launch = true
//    value = "terraform-asg-example"
//  }
//}


resource "aws_security_group" "elb" {
  name = "terraform-example-elb"
//  vpc_id = "${var.vpc_id}"
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "example" {
  name = "terraform-asg-example"
  availability_zones = ["ap-northeast-2a","ap-northeast-2b","ap-northeast-2c", "ap-northeast-2d"]
//  availability_zones = [data.aws_availability_zones.all.names]
  security_groups = ["${aws_security_group.elb.id}"]

  listener {
    instance_port = var.server_port
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    interval = 30
    target = "HTTP:${var.server_port}/"
    timeout = 3
    unhealthy_threshold = 2
  }
  depends_on = [aws_launch_configuration.example]
}

//data "template_file" "user_data" {
//  template = "${file("user-data.sh")}"
//  vars {
//    server_port = "${var.server_port}"
////    db_address = "${data.terraform_remote_state.db.address}"
////    db_port = "${data.terraform_remote_state.db.port}"
//  }
//}





