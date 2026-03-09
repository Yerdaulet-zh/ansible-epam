# Security Group for the Public Classic Load Balancer
resource "aws_security_group" "lb_sg" {
  name        = "classic-lb-sg"
  description = "Allow HTTP traffic from the internet"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for Nginx Instances (Not internet facing)
resource "aws_security_group" "nginx_sg" {
  name        = "nginx-instance-sg"
  description = "Allow traffic ONLY from the Load Balancer"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "nginx_sg_id" {
  value = aws_security_group.nginx_sg.id
  sensitive = true
}

output "lb_sg_id" {
  value = aws_security_group.lb_sg.id
  sensitive = true
}
