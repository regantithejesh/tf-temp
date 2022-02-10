provider "aws" {
  version = "~> 3.0"
  region  = "us-east-1"
  profile = "destination"
}
resource "aws_ecs_cluster" "ecscluster" {
  name = var.clustername
}
resource "aws_ecs_task_definition" "taskdefinition" {
  family                = var.Taskdefinition
  network_mode = "awsvpc"
  execution_role_arn = var.executionrole_arn
  cpu = 512
  memory = 1024
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
    {
      name      = "app-container"
      image     = var.containerimage
      memory    = 512
      essential = true
      mountPoints = [{
          sourceVolume = "efs-volume"
          containerPath = "/var/jenkins_home"
          readOnly = false
        }]
      portMappings = [
        {
          containerPort = 8080

        }
      ]
	  
    }
    
  ])

  volume {
    name = "efs-volume"


    efs_volume_configuration {
      file_system_id          = var.efsvolume
      root_directory          = "/"
      transit_encryption      = "ENABLED"
      transit_encryption_port = 2999
    }
  }
}
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }
}
resource "aws_lb_target_group" "ip-example" {
  name        = "tf-example-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id
}
resource "aws_ecs_service" "ecsservice" {
  name            =  var.servicename
  launch_type = "FARGATE"
  load_balancer {
    target_group_arn = aws_lb_target_group.foo.arn
    container_name   = "mongo"
    container_port   = 8080
  }
  network_configuration {
  subnets = var.subnetid
  security_groups = var.securitygroups
  assign_public_ip = "true"
     }
  cluster         = aws_ecs_cluster.ecscluster.id
  task_definition = aws_ecs_task_definition.taskdefinition.arn
  desired_count   = 1  
}


