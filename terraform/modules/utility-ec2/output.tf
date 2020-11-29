output "elb_dns_name" {
  value = "${aws_elb.example.dns_name}"
}

output "instance_id" {
  value = "${aws_instance.bastion_2a.id}"
}