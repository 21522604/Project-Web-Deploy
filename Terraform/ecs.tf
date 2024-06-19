resource "aws_ecs_cluster" "ecs-cluster" {
  name = var.aws_ecs_cluster_name
}

data "template_file" "backend" {
  template = file("./templates/backend.json.tpl")
  vars = {
    app_image      = aws_ecr_repository.backend.repository_url
    app_port       = 8080
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    tag            = var.tag
    name           = "backend"
  }
}

data "template_file" "frontendadmin" {
  template = file("./templates/frontend-admin.json.tpl")
  vars = {
    app_image      = aws_ecr_repository.frontendadmin.repository_url
    app_port       = 3000
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    tag            = var.tag
    name           = "frontend-admin"
  }
}

data "template_file" "frontendcustomer" {
  template = file("./templates/frontend-customer.json.tpl")
  vars = {
    app_image      = aws_ecr_repository.frontendcustomer.repository_url
    app_port       = 3000
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    tag            = var.tag
    name           = "frontend-customer"
  }
}
//backend-task-def
resource "aws_ecs_task_definition" "backend_task_def" {

  family                   = "backend"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = data.aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  runtime_platform {
    cpu_architecture = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name   = "backend"
      image  = "851725279804.dkr.ecr.us-east-1.amazonaws.com/backend:latest"
      cpu    = 0
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "TCP"
          appProtocol   = "http"
        }
      ]
      essential = true
    }
  ])
}

//frontend-admin-task-def
resource "aws_ecs_task_definition" "frontend_admin_task_def" {

  family                   = "frontend-admin"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = data.aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  runtime_platform {
    cpu_architecture = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name   = "frontend-admin"
      image  = "851725279804.dkr.ecr.us-east-1.amazonaws.com/frontendadmin:latest"
      cpu    = 0
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "TCP"
          appProtocol   = "http"
        }
      ]
      essential = true
    }
  ])
}

//frontend-customer-task-def
resource "aws_ecs_task_definition" "frontend_customer_task_def" {

  family                   = "frontend-customer"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = data.aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  runtime_platform {
    cpu_architecture = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name   = "frontend-customer"
      image  = "851725279804.dkr.ecr.us-east-1.amazonaws.com/frontendcustomer:latest"
      cpu    = 0
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "TCP"
          appProtocol   = "http"
        }
      ]
      essential = true
    }
  ])
}
//backend-service
resource "aws_ecs_service" "backend" {
  name            = "web-backend-svc"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.backend_task_def.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_task.id]
    subnets          = ["subnet-0248511b9bfa2ecc8", "subnet-0ea09cb01334d8ef9", "subnet-08c0f35ca6f7392db", "subnet-0beef78c3b66bcb62"]
    assign_public_ip = true
  }

  depends_on = [
    aws_ecr_repository.backend,
    aws_ecs_task_definition.backend_task_def
  ]

}

//frontend-admin-service
resource "aws_ecs_service" "frontendadmin" {
  name            = "web-frontend-admin-svc"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.frontend_admin_task_def.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_task.id]
    subnets          = ["subnet-0248511b9bfa2ecc8", "subnet-0ea09cb01334d8ef9", "subnet-08c0f35ca6f7392db", "subnet-0beef78c3b66bcb62"]
    assign_public_ip = true
  }

  depends_on = [
    aws_ecr_repository.frontendadmin,
    aws_ecs_task_definition.frontend_admin_task_def,
    aws_ecs_service.backend
  ]

}

//frontend-customer-service
resource "aws_ecs_service" "frontendcustomer" {
  name            = "web-frontend-customer-svc"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.frontend_customer_task_def.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_task.id]
    subnets          = ["subnet-0248511b9bfa2ecc8", "subnet-0ea09cb01334d8ef9", "subnet-08c0f35ca6f7392db", "subnet-0beef78c3b66bcb62"]
    assign_public_ip = true
  }

  depends_on = [
    aws_ecr_repository.frontendcustomer,
    aws_ecs_task_definition.frontend_admin_task_def,
    aws_ecs_service.backend
  ]

}
