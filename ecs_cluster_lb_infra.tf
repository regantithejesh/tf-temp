provider "aws" {
  version = "~> 3.0"
  region  = "us-east-1"
}
resource "aws_ecs_cluster" "ecs__cluster" {
  name = var.cluster_name
}
resource "aws_lb" "nt_lb" {
  name               = var.lb_env_tag
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnets
  tags = {
    Environment = var.lb_tg
  }
}
output "cluster_arn" {
  value       = aws_ecs_cluster.ecs__cluster.arn
  description = "ecs cluster arn"
}
output "lb_arn" {
  value       = aws_lb.nt_lb.arn
  description = "load balancer arn"
}
