resource "aws_elb" "nginx_lb" {
  name            = "nginx-classic-lb"
  subnets         = [data.terraform_remote_state.network.outputs.public_subnet_id]
  security_groups = [data.terraform_remote_state.network.outputs.lb_sg_id]
  # availability_zones = ["eu-south-1a", "eu-south-1b"]
  
  # access_logs {
  #   bucket        = "epam-logs" // This bucket has globally unique name :) 
  #   bucket_prefix = "epam-terraform-logs"
  #   interval      = 60
  # }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances = aws_instance.nginx[*].id
  cross_zone_load_balancing   = false
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "terraform-elb"
  }
}
