variable "project_name" {
  description = "project name"
  type        = string
}

variable "aws_region_short" {
  description = "aws region short"
  type        = string
}
variable "devops_user_names" {
  description = "DevOps team user names for IAM Terraform"
  type        = "list"
}
variable "developer_user_names" {
  description = "Developer console user names for IAM"
  type        = "list"
}
variable "circleci_user_names" {
  description = "CircleCi user names for IAM"
  type = "list"
}
variable "etl_user_names" {
  description = "ETL user names for IAM"
  type = "list"
}
variable "devops_policy_arn" {
  description = "DevOps team user names for IAM"
  type = string
  default =  "arn:aws:iam::aws:policy/AdministratorAccess"
}
variable "developers_policy_arn" {
  description = "Developer console user names for IAM"
  type = string
  default = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
variable "user_change_password_policy_arn" {
  description = "All users have this user change password policy when access to their account at first time"
  type = string
  default = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}