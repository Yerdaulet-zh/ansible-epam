resource "aws_instance" "nginx" {
  count         = 2
  ami           = local.ami
  instance_type = "t3.micro"

  subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_id
  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.nginx_sg_id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update && sudo apt upgrade -y
              sudo apt install nginx
              sudo systemctl start nginx
              sudo systemctl restart nginx
              
              echo "<h1>Hello from $(hostname)</h1>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "Nginx-Server-${count.index + 1}"
  }
}
