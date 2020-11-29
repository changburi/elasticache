output "vpc_id" {
  description = "VPC ID"
  value       = "${aws_vpc.vpc.id}"
}
output "public_2a_id" {
  description = "public_2a subnet"
  value       = "${aws_subnet.public_2a.id}"
}
output "private_2a_id" {
  description = "private_2a subnet"
  value       = "${aws_subnet.private_2a.id}"
}
output "public_2c_id" {
  description = "public_2c subnet"
  value       = "${aws_subnet.public_2c.id}"
}
output "private_2c_id" {
  description = "private_2c subnet"
  value       = "${aws_subnet.private_2c.id}"
}