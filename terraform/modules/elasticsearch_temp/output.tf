output "domain_name" {
  value       = join("", aws_elasticsearch_domain.default.*.domain_name)
  description = "(Required) Name of the domain."
}
output "domain_arn" {
  value       = join("", aws_elasticsearch_domain.default.*.arn)
  description = "Amazon Resource Name (ARN) of the domain."
}

output "domain_id" {
  value       = join("", aws_elasticsearch_domain.default.*.domain_id)
  description = "Unique identifier for the domain."
}

output "domain_endpoint" {
  value       = join("", aws_elasticsearch_domain.default.*.endpoint)
  description = "Domain-specific endpoint used to submit index, search, and data upload requests."
}

output "elasticsearch_version" {
  value       = join("", aws_elasticsearch_domain.default.*.elasticsearch_version)
  description = "(Optional) The version of Elasticsearch to deploy. Defaults to 1.5"
}

output "ebs_options-ebs_enabled" {
  value       = join("", aws_elasticsearch_domain.default.ebs_options.*.ebs_enabled)
  description = " (Required) Whether EBS volumes are attached to data nodes in the domain."
}

output "ebs_options-volume_size" {
  value       = join("", aws_elasticsearch_domain.default.ebs_options.*.volume_size)
  description = "The size of EBS volumes attached to data nodes (in GB). Required if ebs_enabled is set to true."
}

output "ebs_options-volume_type" {
  value       = join("", aws_elasticsearch_domain.default.ebs_options.*.volume_type)
  description = "(Optional) The type of EBS volumes attached to data nodes."
}

output "ebs_options-iops" {
  value       = join("", aws_elasticsearch_domain.default.ebs_options.*.iops)
  description = " (Optional) The baseline input/output (I/O) performance of EBS volumes attached to data nodes. Applicable only for the Provisioned IOPS EBS volume type."
}

output "cluster_config-instance_count" {
  value       = join("", aws_elasticsearch_domain.default.cluster_config.*.instance_count)
  description = "(Optional) Number of instances in the cluster."
}

output "cluster_config-instance_type" {
  value       = join("", aws_elasticsearch_domain.default.cluster_config.*.instance_type)
  description = "(Optional) Instance type of data nodes in the cluster."
}

output "cluster_config-dedicated_master_enabled" {
  value       = join("", aws_elasticsearch_domain.default.cluster_config.*.dedicated_master_enabled)
  description = "(Optional) Indicates whether dedicated master nodes are enabled for the cluster."
}

output "cluster_config-dedicated_master_count" {
  value       = aws_elasticsearch_domain.default.cluster_config.*.dedicated_master_count
  description = "(Optional) Number of dedicated master nodes in the cluster"
}

output "cluster_config-dedicated_master_type" {
  value       = join("", aws_elasticsearch_domain.default.cluster_config.*.dedicated_master_type)
  description = "(Optional) Instance type of the dedicated master nodes in the cluster."
}

output "cluster_config-zone_awareness_enabled" {
  value       = join("", aws_elasticsearch_domain.default.cluster_config.*.zone_awareness_enabled)
  description = "(Optional) Indicates whether zone awareness is enabled, set to true for multi-az deployment."
}

output "snapshot_options-automated_snapshot_start_hour" {
  value       = join("", aws_elasticsearch_domain.default.snapshot_options.*.automated_snapshot_start_hour)
  description = "(Required) Hour during which the service takes an automated daily snapshot of the indices in the domain."
}

output "advanced_security_options-enabled" {
  value       = join("", aws_elasticsearch_domain.default.advanced_security_options.*.enabled)
  description = "(Required, Forces new resource) Whether advanced security is enabled"
}

output "domain_endpoint_options-enforce_https" {
  value       = join("", aws_elasticsearch_domain.default.domain_endpoint_options.*.enforce_https)
  description = "(Required) Whether or not to require HTTPS"
}

output "domain_endpoint_options-tls_security_policy" {
  value       = join("", aws_elasticsearch_domain.default.domain_endpoint_options.*.tls_security_policy)
  description = " (Optional) The name of the TLS security policy that needs to be applied to the HTTPS endpoint."
}

output "encrypt_at_rest-enabled" {
  value       = join("", aws_elasticsearch_domain.default.encrypt_at_rest.*.enabled)
  description = "(Required) Whether to enable encryption at rest. If the encrypt_at_rest block is not provided then this defaults to false"
}

output "encrypt_at_rest-kms_key_id" {
  value       = join("", aws_elasticsearch_domain.default.encrypt_at_rest.*.kms_key_id)
  description = "(Optional) The KMS key id to encrypt the Elasticsearch domain with. If not specified then it defaults to using the aws/es service KMS key."
}

output "node_to_node_encryption_enabled-enabled" {
  value       = join("", aws_elasticsearch_domain.default.node_to_node_encryption.*.enabled)
  description = "(Optional) Node-to-node encryption options. See below."
}

output "log_publishing_index_cloudwatch_log_group_arn" {
  value = join(",", aws_cloudwatch_log_group.maps.*.arn)
  description = "ARN of the CloudWatch log group to which log for INDEX_SLOW_LOGS needs to be published"
}

output "log_publishing_search_cloudwatch_log_group_arn" {
  value = join(",",aws_cloudwatch_log_group.maps.*.arn)
  description = "ARN of the CloudWatch log group to which log for SEARCH_SLOW_LOGS needs to be published"
}

output "log_publishing_application_cloudwatch_log_group_arn" {
  value = join(",", aws_cloudwatch_log_group.maps.*.arn)
  description = "ARN of the CloudWatch log group to which log for ES_APPLICATION_LOGS needs to be published"
}

output "elasticsearch_allowed_source_ip" {
  value = var.elasticsearch_allowed_source_ip
  description = "Allowed ip address to access kibana for elasticsearch"
}
