variable "cluster_name" {
  type = string
  description = "specify cluster name"
  default     = "ecsclustertest"
}
variable "subnets" {
  type = list(string)
  description = "specify subnets for load balancer"
  default     = ["subnet-00df62d333354c0ce","subnet-054778eceb28d0147"] 
}
variable "lb_name" {
  type = string
  description = "specify load balancer name"
  default     = "sto-ecs-ms-lb"
}
variable "lb_env_tag" {
  type = string
  description = "specify environment"
  default     = "dev"
}



