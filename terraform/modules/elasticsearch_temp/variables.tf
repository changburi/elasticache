variable "project_name" {
  description = "project name"
  type        = string
}
variable "aws_region_short" {
  description = "aws region short"
  type        = string
}

variable "domain_name" {
  type        = string
  default     = ""
  description = "name of Elasticsearch Domain for MAPS"
}

variable "elasticsearch_version" {
  type        = string
  default     = "1.5"
  description = "Version of Elasticsearch to deploy"
}

variable "instance_type" {
  type        = string
  default     = "r5.large.elasticsearch"
  description = "Elasticsearch instance type for data nodes in the cluster"
}

variable "instance_count" {
  description = "Number of data nodes in the cluster"
  default     = 1
}

variable "zone_awareness_enabled" {
  default     = false
  description = "Enable zone awareness for Elasticsearch cluster"
}

variable "availability_zone_count" {
  default     = 2
  description = "Number of Availability Zones for the domain to use."
}

variable "ebs_volume_size" {
  description = "EBS volumes for data storage in GB"
  default     = 10
}

variable "ebs_volume_type" {
  type        = string
  default     = "gp2" // General Purpose,   https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volume-types.html
  description = "Storage type of EBS volumes"
}

variable "ebs_iops" {
  default     = 0 // Provisioned IOPS* value when user select "io1" for volume type
  description = "The baseline input/output (I/O) performance of EBS volumes attached to data nodes. Applicable only for the Provisioned IOPS EBS volume type"
}

variable "encrypt_at_rest_enabled" {
  default     = false
  description = "Whether to enable encryption at rest"
}

variable "encrypt_at_rest_kms_key_id" {
  type        = string
  default     = "aws/es"
  description = "The KMS key ID to encrypt the Elasticsearch domain with. If not specified, then it defaults to using the AWS/Elasticsearch service KMS key"
}

variable "log_publishing_index_enabled" {
  default     = false
  description = "Specifies whether log publishing option for INDEX_SLOW_LOGS is enabled or not"
}

variable "log_publishing_search_enabled" {
  default     = false
  description = "Specifies whether log publishing option for SEARCH_SLOW_LOGS is enabled or not"
}

variable "log_publishing_application_enabled" {
  default     = false
  description = "Specifies whether log publishing option for ES_APPLICATION_LOGS is enabled or not"
}

variable "log_publishing_index_cloudwatch_log_group_arn" {
  type        = string
  default     = ""
  description = "ARN of the CloudWatch log group to which log for INDEX_SLOW_LOGS needs to be published"
}

variable "log_publishing_search_cloudwatch_log_group_arn" {
  type        = string
  default     = ""
  description = "ARN of the CloudWatch log group to which log for SEARCH_SLOW_LOGS needs to be published"
}

variable "log_publishing_application_cloudwatch_log_group_arn" {
  type        = string
  default     = ""
  description = "ARN of the CloudWatch log group to which log for ES_APPLICATION_LOGS needs to be published"
}

variable "automated_snapshot_start_hour" {
  description = "Hour at which automated snapshots are taken, in UTC"
  default     = 0
}

variable "advanced_security_options" {
  description = "Fine-grained access control"
  default     = false
}

variable "dedicated_master_enabled" {
  default     = false
  description = "Indicates whether dedicated master nodes are enabled for the cluster"
}

variable "dedicated_master_count" {
  description = "Number of dedicated master nodes in the cluster"
  default     = 3
}

variable "dedicated_master_type" {
  type        = string
  default     = "r5.large.elasticsearch"
  description = "Instance type of the dedicated master nodes in the cluster"
}

variable "rest_action_multi_allow_explicit_index" {
  default     = false
  description = "Key-value string pairs to specify advanced configuration options"
}

variable "node_to_node_encryption_enabled" {
  default     = false
  description = "Whether to enable node-to-node encryption"
}

variable "elasticsearch_allowed_source_ip" {
  type = list
  default     = []
  description = "Allowed ip address to access kibana for elasticsearch"
}
//variable "warm_enabled" {
//  default     = false
//  description = "(Optional) Indicates whether to enable warm storage."
//}
//
//variable "warm_count" {
//  default     = 3
//  description = "(Optional) The number of warm nodes in the cluster. Valid values are between 2 and 150."
//}
//
//variable "warm_type" {
//  type = string
//  default     = "ultrawarm1.medium.elasticsearch"
//  description = "(Optional) The instance type for the Elasticsearch cluster's warm nodes. Valid values are ultrawarm1.medium.elasticsearch, ultrawarm1.large.elasticsearch and ultrawarm1.xlarge.elasticsearch. "
//}
