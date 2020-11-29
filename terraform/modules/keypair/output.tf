output "bastion_key" {
  description = "BASTION Key Pair"
  value       = "${aws_key_pair.bastion_key}"
}