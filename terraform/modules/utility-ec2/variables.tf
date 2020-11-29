variable "project_name" {
  description = "project name"
  type        = string
}
variable "aws_region_short" {
  description = "aws region short"
  type        = string
}
//variable "dev_keyname" {
//  description = "2dal-dev"
//  type = string
//  default = "2dal-dev"
//}
variable "bastion" {
  description = "bastion id"
//  type = string
}
variable "dev_default" {
  description = "dev default id"
//  type = string
}
//variable "ssh" {
//  description = "ssh id"
////  type = string
//}
variable "public_2a_id" {
  description = "public_2a subnet"
}
variable "private_2a_id" {
  description = "private_2a subnet"
}
variable "public_2c_id" {
  description = "public_2c subnet"
}
variable "private_2c_id" {
  description = "private_2c subnet"
}
//variable "bastion_key_name" {
//  description = "bastion key"
////  type = string
//}
variable "vpc_id" {
  description = "vpc_id"
  type        = string
}


variable "cluster_name" {
  description = "The name to use for all the cluster resources"
}
variable "server_port" {
  description = "The port the server will use for HTTP resquests"
  default = 8080
}
variable "instance_type" {
  description = "The type of EC2 instances to run (e.g.. t2.micro)"
}
variable "min_size" {
  description = "The minimum number of EC2 instances in the ASG"
}
variable "max_size" {
  description = "The maximum number of EC2 instnaces in the ASG"
}