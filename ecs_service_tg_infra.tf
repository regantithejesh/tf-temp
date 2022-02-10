provider "aws" {
  version = "~> 3.0"
  region  = "us-east-1"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = var.instanceprofile_name
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = var.iam_role
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}
resource "aws_iam_policy" "ec2_iampolicy" {
  name        = "ec2_access_policy"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",

        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
	  "s3:*",
	  "secretsmanager:*",
	  "kms:DescribeKey",
                "kms:ListAliases",
                "kms:ListKeys"
				
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
	{
            "Sid": "CloudWatchAccess",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        },
        {
            "Sid": "MemoryMetric",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData",
                "ec2:DescribeTags",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:ListMetrics"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeAssociation",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ssm:GetDocument",
                "ssm:DescribeDocument",
                "ssm:GetManifest",
                "ssm:GetParameters",
                "ssm:ListAssociations",
                "ssm:ListInstanceAssociations",
                "ssm:PutInventory",
                "ssm:PutComplianceItems",
                "ssm:PutConfigurePackageResult",
                "ssm:UpdateAssociationStatus",
                "ssm:UpdateInstanceAssociationStatus",
                "ssm:UpdateInstanceInformation",
                "ssm:ResumeSession",
                "ssm:DescribeSessions",
                "ssm:StartSession",
                "ssm:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2messages:AcknowledgeMessage",
                "ec2messages:DeleteMessage",
                "ec2messages:FailMessage",
                "ec2messages:GetEndpoint",
                "ec2messages:GetMessages",
                "ec2messages:SendReply"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstanceStatus"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ds:CreateComputer",
                "ds:DescribeDirectories"
            ],
            "Resource": "*"
        }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "ec2_iam_attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.ec2_iampolicy.arn
}
resource "aws_launch_template" "ecs_lt" {
  name = var.lt_name
  network_interfaces {
    associate_public_ip_address = true
    security_groups=var.securitygroups
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  image_id = var.imageid
  instance_type = var.instancetype
  key_name = var.keypair
    tags = {
      Name = "ec2-server"
    }
  
  user_data = filebase64("user_data.sh")
}
resource "aws_autoscaling_group" "ecs_ec2_asg" {
  name = var.asg_name
  vpc_zone_identifier = var.subnetid
  desired_capacity   = 0
  max_size           = 0
  min_size           = 0

  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }
}



