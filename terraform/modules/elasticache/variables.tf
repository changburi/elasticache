variable "project_name" {
  description = "project name"
  type        = string
}
variable "aws_region_short" {
  description = "aws region short"
  type        = string
}

variable "redis_cluster_mode_enabled" {
  description = "Set redis cluster mode"
  type = string
}