resource "aws_ecs_cluster" "polygon_cluster" {
  name = "polygon-cluster" # Name your cluster here
}

resource "aws_ecs_task_definition" "polygon_task" {
  family                   = "polygon-task" # Name your task
  # ${aws_db_instance.mysql_rds.endpoint}
  container_definitions    = <<DEFINITION
  [
    {
      "name": "polygon-task",
      "image": "${aws_ecr_repository.polygon_container_hub.repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8000,
          "hostPort": 8000
        }
      ],
      "environment": [
        {
          "name": "MYSQL_HOST",
          "value": "x" 
        },
        {
          "name": "MYSQL_PORT",
          "value": "3306"
        },
        {
          "name": "MYSQL_DATABASE",
          "value": "${var.RDS_DATABASE}"
        },
        {
          "name": "MYSQL_USER",
          "value": "${var.RDS_USER}"
        },
        {
          "name": "MYSQL_PASSWORD",
          "value": "${var.RDS_PASSWORD}"
        },
        {
          "name": "PROFILE_NAME",
          "value": "${var.PROFILE_NAME}"
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # use Fargate as the launch type
  network_mode             = "awsvpc"    # add the AWS VPN network mode as this is required for Fargate
  memory                   = 512         # Specify the memory the container requires
  cpu                      = 256         # Specify the CPU the container requires
  execution_role_arn       = "${aws_iam_role.ecs_task_polygon_role.arn}"
}

resource "aws_iam_role" "ecs_task_polygon_role" {
  name               = "ecs-task-polygon-role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_polygon_role_policy" {
  role       = "${aws_iam_role.ecs_task_polygon_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_service" "polygon_ecs_service" {
  name            = "Polygon-ecs-ervice"     # Name the service
  cluster         = "${aws_ecs_cluster.polygon_cluster.id}"   # Reference the created Cluster
  task_definition = "${aws_ecs_task_definition.polygon_task.arn}" # Reference the task that the service will spin up
  launch_type     = "FARGATE"
  desired_count   = 1 # Set up the number of containers to 3

  load_balancer {
    target_group_arn = "${aws_lb_target_group.polygon_lb_target_group.arn}" # Reference the target group
    container_name   = "${aws_ecs_task_definition.polygon_task.family}"
    container_port   = 8000 # Specify the container port
  }

  network_configuration {
    subnets          = ["${aws_default_subnet.polygon_default_subnet_1.id}", "${aws_default_subnet.polygon_default_subnet_2.id}"]
    assign_public_ip = true     # Provide the containers with public IPs
    security_groups  = ["${aws_security_group.polygon_security_group.id}"] # Set up the security group
  }
}

resource "aws_security_group" "polygon_security_group" {
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = ["${aws_security_group.polygon_lb_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
