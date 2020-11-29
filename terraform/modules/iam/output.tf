output "devops-users-name" {
  description = "Terraform Users list of DevOps team"
  value       = aws_iam_user.devops.*.name
}
output "developers-users-name" {
  description = "Developers list except for DevOps team"
  value       = aws_iam_user.developer.*.name
}