resource "aws_elasticache_cluster" "redis_cluster" {
  count                = "${var.redis_cluster_mode_enabled !="" ? 1 : 0}"
  cluster_id           = "cluster-example"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  port                 = 6379
}

resource "aws_elasticache_cluster" "redis_replica" {
  count                =  "${var.redis_cluster_mode_enabled !="" ? 0 : 1}"
  cluster_id           = "cluster-example"
  replication_group_id = "${aws_elasticache_replication_group.redis_cluster_mode_replication_group.id}"
}

//resource "aws_elasticache_parameter_group" "default_parameter" {
//  name   = "cache-params"
//  family = "redis5.0"
//
//  parameter {
//    name  = "activerehashing"
//    value = "yes"
//  }
//
//  parameter {
//    name  = "min-slaves-to-write"
//    value = "2"
//  }
//}

resource "aws_elasticache_replication_group" "redis_replication_group" {
//  count                         = "1 - ${var.redis_cluster_mode_enabled !="" ? 1 : 0}"
  automatic_failover_enabled    = true
  availability_zones            = ["ap-northeast-2a", "ap-northeast-2c"]
  replication_group_id          = "tf-rep-group-1"
  replication_group_description = "test description"
  node_type                     = "cache.t2.micro"
  number_cache_clusters         = 2
  parameter_group_name          = "default.redis5.0"
  port                          = 6379
}

resource "aws_elasticache_replication_group" "redis_cluster_mode_replication_group" {
//  count                         =  "${var.redis_cluster_mode_enabled !="" ? 1 : 0}"
  automatic_failover_enabled    = true
  availability_zones            = ["ap-northeast-2a", "ap-northeast-2c"]
  replication_group_id          = "tf-rep-group-1"
  replication_group_description = "test description"
  node_type                     = "cache.t2.micro"
  number_cache_clusters         = 2
  parameter_group_name          = "default.redis5.0"
  port                          = 6379

  lifecycle {
    ignore_changes = [number_cache_clusters]
  }
}

//resource "aws_elasticache_cluster" "replica" {
//  count = 1
//
//  cluster_id           = "tf-rep-group-1-${count.index}"
//  replication_group_id = aws_elasticache_replication_group.example.id
//}