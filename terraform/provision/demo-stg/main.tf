provider "aws" {
  region  = "ap-northeast-2"
  profile = "ocj_home"
}

module "iam" {
  source                = "../../modules/iam"
  project_name          = "devops"
  aws_region_short      = "su"
  devops_user_names     = ["devops"]
  developer_user_names  = ["developer"]
  circleci_user_names    = ["circleci"]
  etl_user_names         = ["etl"]
  devops_policy_arn     = "arn:aws:iam::aws:policy/AdministratorAccess"
  developers_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  user_change_password_policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

//module "keypair" {
//  source           = "../../modules/keypair"
//  project_name     = "devops"
//  aws_region_short = "su"
////  bastion_key      = file("C:/Users/cj/.ssh/web_admin.pub")
//  bastion_key      = file("C:/Users/cjub.oh.CORP/.ssh/web_admin.pub")
//}

module "rds" {
  source           = "../../modules/rds"
  project_name     = "devops"
  aws_region_short = "su"
}

module "role" {
  source = "../../modules/role"
  aws_region = "ap-northeast-2"
  env = "stg"
  project_name = "devops"
}

module "vpc" {
  source           = "../../modules/vpc"
  project_name     = "devops"
  aws_region_short = "su"
}

module "sg" {
  source           = "../../modules/sg"
  project_name     = "devops"
  aws_region_short = "su"
  vpc_id           = "${module.vpc.vpc_id}"
}

module "utility-ec2" {
  source           = "../../modules/utility-ec2"
  project_name     = "devops"
  aws_region_short = "su"
//  dev_keyname      = "2dal-dev"
//  dev_keyname      = "${module.keypair.bastion_key}"
  bastion          = "${module.sg.bastion}"
  dev_default      = "${module.sg.dev_default}"
//  ssh              = "${module.sg.ssh}"
  public_2a_id     = "${module.vpc.public_2a_id}"
  private_2a_id    = "${module.vpc.private_2a_id}"
  public_2c_id     = "${module.vpc.public_2c_id}"
  private_2c_id    = "${module.vpc.private_2c_id}"
//  bastion_key_name = "${module.keypair.bastion_key}"
  min_size = 2
  max_size = 3
  instance_type = "t2.micro"
  cluster_name = "webservers_stg"
  vpc_id = "${module.vpc.vpc_id}"
}

//module "elasticsearch" {
//  source            = "..\/..\/modules\/elasticsearch_temp"
//  project_name     = "devops"
//  aws_region_short = "su"
////    source                         = "../../"
////    namespace                      = var.namespace
////    stage                          = var.stage
////    name                           = var.name
//  //  security_groups                = [module.vpc.vpc_default_security_group_id]
////  security_groups       = [module.sg.dev_default]
////  vpc_id                = module.vpc.vpc_id
////  subnet_ids            = module.subnets.private_subnet_ids
//
//  # Domain Name
//  domain_name           = "maps-es-domain"
//  # Elasticsearch version
//  elasticsearch_version = "7.7"
//  # cluster_config
//  instance_type   = "r5.large.elasticsearch"
//  instance_count  = 1
//  # Data nodes storage
//  ebs_volume_size = 100
//  ebs_volume_type = "gp2"
//  # Snapshot options
//  automated_snapshot_start_hour = 0
//  advanced_security_options     = false
//
//  rest_action_multi_allow_explicit_index = true
//
//  # Dedicated master nodes
//  dedicated_master_enabled = false
//  dedicated_master_count   = 3
//  dedicated_master_type    = ""
//
//  # Data nodes
//  zone_awareness_enabled  = false
//  availability_zone_count = 2
//
//  # Encryption
//  encrypt_at_rest_enabled                             = false
//  encrypt_at_rest_kms_key_id                          = ""
//  node_to_node_encryption_enabled                     = true
//
//  log_publishing_search_enabled                       = true
//  log_publishing_search_cloudwatch_log_group_arn      = module.elasticsearch.log_publishing_search_cloudwatch_log_group_arn
//
//  log_publishing_index_enabled                        = true
//  log_publishing_index_cloudwatch_log_group_arn       = module.elasticsearch.log_publishing_index_cloudwatch_log_group_arn
//
//  log_publishing_application_enabled                  = true
//  log_publishing_application_cloudwatch_log_group_arn = module.elasticsearch.log_publishing_application_cloudwatch_log_group_arn
//
//  elasticsearch_allowed_source_ip = ["210.94.41.89/32"]
//}
//

module "cloudwatch" {
  source           = "../../modules/cloudwatch"
  project_name     = "devops"
  aws_region_short = "su"
  alarms_email     = "changburi@gmail.com"
  instance_id        = "${module.utility-ec2.instance_id}"
}

//module "elasticache" {
//  source           = "../../modules/elasticache"
//  project_name     = "devops"
//  aws_region_short = "su"
//  redis_cluster_mode_enabled = ""
//}