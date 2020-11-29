output "bastion" {
  description = "BASTION Security Group"
  value       = "${aws_security_group.bastion}"
}

output "dev_default" {
  description = "dev_default Security Group"
  value       = "${aws_default_security_group.dev_default}"
}

//output "ssh" {
//  description = "ssh Security Group"
//  value       = "${aws_security_group.ssh}"
//}