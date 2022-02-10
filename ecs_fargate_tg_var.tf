variable "clustername" {
  description = "specify ecs cluster name to create"
  type = string
  default     = "ecs-test-cluster"
}
variable "executionrole_arn" {
  type = string
  description = "specify execution role arn"
  default     = "arn:aws:iam::864413304142:role/ecs-task-execution-role"
}
variable "containerimage" {
  type = string
  description = "specify image url"
  default     = "864413304142.dkr.ecr.us-east-1.amazonaws.com/jenkins:latest"
}
variable "containerport" {
  type = string
  description = "specify container port"
  default     = "8080"
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
variable "efsvolume" {
  type = string
  description = "specify efs id to mount"
  default     = "fs-07f5ecec9ace1485d"
}
variable "servicename" {
  type = string
  description = "specify service name"
  default     = "sto-jenkins-test-service"
}
variable "Taskdefinition" {
  type = string
  description = "specify Task definition name"
  default     = "sto-jenkins-test--TD"
}


