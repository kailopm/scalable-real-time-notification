resource "aws_elasticache_subnet_group" "notification_redis_subnet_group" {
  name        = "notification-redis-subnet-group"
  description = "ElastiCache Subnet Group for Redis"

  subnet_ids = [
    aws_subnet.notification_subnet_1.id,
    aws_subnet.notification_subnet_2.id
  ]
}

resource "aws_elasticache_cluster" "notification_redis" {
  cluster_id           = "notification-redis"
  engine               = "redis"
  engine_version       = "6.x"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  subnet_group_name    = aws_elasticache_subnet_group.notification_redis_subnet_group.id
  port                 = 6379
}
