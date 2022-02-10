
variable "asgname" {
  type = string
  description = "specify ecs autoscaling group name"
  default     = "sto-ecs-cluster-asg"
}
variable "lt_name" {
  type = string
  description = "specify launch template name"
  default     = "sto-ecs-test-lt"
}
variable "imageid" {
  type = string
  description = "specify ecs optimized ami id"
  default     = "ami-0c5c9bcfb36b772fe"
}
variable "instancetype" {
  type = string
  description = "specify instance type"
  default     = "t2.micro"
}
variable "keypair" {
  type = string
  description = "specify key pair for ecs server"
  default     = "sto-app-dev-api-kp"
}
variable "subnetid" {
  type = list(string)
  description = "specify subnetid for task"
  default     = ["subnet-00df62d333354c0ce"]
}
variable "securitygroups" {
  type = list(string)
  description = "specify securitygroupid"
  default     = ["sg-0d662eeca09cfab3a"]
}
variable "ec2_role_name" {
  type = string
  description = "specify role name"
  default     = "ecs-ec2-role"
}
variable "instance_profile_name" {
  type = string
  description = "specify profile name"
  default     = "ecs-ec2-srvr-profile"
}




