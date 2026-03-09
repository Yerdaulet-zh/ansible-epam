resource "aws_instance" "ansible" {
  count         = 2
  ami           = local.ami
  instance_type = "t3.micro"
  key_name      = local.ssh_key_name

  subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_id
  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.sg_id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update && sudo apt upgrade -y
              EOF

  tags = {
    Name = "Server-${count.index + 1}"
  }
}
