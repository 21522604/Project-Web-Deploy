resource "aws_security_group" "ecs_task" {
  name   = var.aws_sg_name
  vpc_id = "vpc-047c36f6e2573fb40"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}
