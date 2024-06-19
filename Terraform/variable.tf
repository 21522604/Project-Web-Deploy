variable "region" {
  default = "us-east-1"
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}


variable "ecs_iam_role_name" {
  type        = string
  description = "Enter a name for the ECS IAM Role"
  default     = "ecsTaskExecutionRole"
}

variable "aws_ecs_cluster_name" {
  type        = string
  description = "Enter a name for ECS cluster"
  default     = "web-cluster"
}



variable "fargate_cpu" {
  type        = number
  description = "enter required number of cpus"
  default     = 2048
}

variable "fargate_memory" {
  type        = number
  description = "Enter required memory"
  default     = 5120
}

variable "aws_sg_name" {
  type        = string
  description = "security group name"
  default     = "web_sg"
}

variable "tag" {
  type    = string
  default = "demo"
}

variable "environment" {
  type        = string
  description = "Add the environment name"
  default     = "demo"
}

variable "ecs_task_execution_role_name" {
  type    = string
  default = "ecsTaskExecutionRole"
}