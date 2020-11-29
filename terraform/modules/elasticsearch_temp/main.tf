data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_elasticsearch_domain" "default" {
  domain_name           = var.domain_name   // domain name?
  elasticsearch_version = var.elasticsearch_version

  # https://docs.aws.amazon.com/ko_kr/elasticsearch-service/latest/developerguide/es-ac.html
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = var.rest_action_multi_allow_explicit_index
  }

  ebs_options {
    ebs_enabled = var.ebs_volume_size > 0 ? true : false
    volume_size = var.ebs_volume_size
    volume_type = var.ebs_volume_type
    iops        = var.ebs_iops
  }

  cluster_config {
    instance_count           = var.instance_count
    instance_type            = var.instance_type
    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_count   = var.dedicated_master_count
    dedicated_master_type    = var.dedicated_master_type
    zone_awareness_enabled   = var.zone_awareness_enabled

    # Availability zones
//    zone_awareness_config {
//      availability_zone_count = var.availability_zone_count
//    }
  }

  # Start hour for the daily
  snapshot_options {
    automated_snapshot_start_hour = var.automated_snapshot_start_hour
  }

  # Fine-grained access control
  advanced_security_options {
    enabled = var.advanced_security_options
  }

  # Encryption at rest
  encrypt_at_rest {
    enabled    = var.encrypt_at_rest_enabled
    kms_key_id = var.encrypt_at_rest_kms_key_id
  }

  # Node-to-node encryption
  node_to_node_encryption {
    enabled = var.node_to_node_encryption_enabled
  }

  log_publishing_options {
    enabled                  = var.log_publishing_index_enabled
    log_type                 = "INDEX_SLOW_LOGS"
    cloudwatch_log_group_arn = var.log_publishing_index_cloudwatch_log_group_arn
  }

  log_publishing_options {
    enabled                  = var.log_publishing_search_enabled
    log_type                 = "SEARCH_SLOW_LOGS"
    cloudwatch_log_group_arn = var.log_publishing_search_cloudwatch_log_group_arn
  }

  log_publishing_options {
    enabled                  = var.log_publishing_application_enabled
    log_type                 = "ES_APPLICATION_LOGS"
    cloudwatch_log_group_arn = var.log_publishing_application_cloudwatch_log_group_arn
  }

  depends_on = [aws_cloudwatch_log_resource_policy.elasticsearch-log-publishing-policy]
  tags = {
    Domain = "Maps-ES"
  }
  lifecycle {
    ignore_changes = [
      "log_publishing_options"
    ]
  }
}

data "aws_iam_policy_document" "elasticsearch_default" {
  statement {
    actions = ["es:*", ]
    resources = [
      "${join("", aws_elasticsearch_domain.default.*.arn)}/*"
    ]
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test = "IpAddress"
      values = var.elasticsearch_allowed_source_ip
      variable = "aws:SourceIp"
    }
  }
}

resource "aws_elasticsearch_domain_policy" "default" {
  domain_name     = aws_elasticsearch_domain.default.domain_name
  access_policies = join("", data.aws_iam_policy_document.elasticsearch_default.*.json)
}

resource "aws_cloudwatch_log_group" "maps" {
  name = "maps"
}

data "aws_iam_policy_document" "elasticsearch-log-publishing-policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]

    resources = ["arn:aws:logs:*"]

    principals {
      identifiers = ["es.amazonaws.com"]
      type        = "Service"
    }
  }
}
resource "aws_cloudwatch_log_resource_policy" "elasticsearch-log-publishing-policy" {
  policy_document = data.aws_iam_policy_document.elasticsearch-log-publishing-policy.json
  policy_name     = "elasticsearch-log-publishing-policy"
}

//# Role that pods can assume for access to elasticsearch and kibana
//resource "aws_iam_role" "elasticsearch_user" {
//  name               = "elasticsearch_user"
//  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)
//  description        = "IAM Role to assume to access the Elasticsearch module.label.id cluster"
//
//  tags = {
//    tag-key = "tag-value"
//  }
//}
//
//data "aws_iam_policy_document" "assume_role" {
//  statement {
//    actions = [
//      "sts:AssumeRole"
//    ]
//    principals {
//    type        = "Service"
//      identifiers = ["ec2.amazonaws.com"]
//    }
//    principals {
//      type        = "AWS"
//      identifiers = ["*"]
//    }
//    effect = "Allow"
//  }
//}
