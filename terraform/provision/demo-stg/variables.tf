variable "devops_user_names" {
  description = "DevOps team user names for IAM Terraform"
  type        = "list"
  default     = ["devops"]
}
variable "developer_user_names" {
  description = "Developer console user names for IAM"
  type        = "list"
  default     = ["raegon.kim@samsung.com", "sjae0220.lee@samsung.com", ]
}
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
}
variable "env" {
  description = "env"
  type        = string
  default = "stg"
}
variable "aws_region" {
  description = "aws region"
  type        = string
  default = "ap-northeast-2"
}