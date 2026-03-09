data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket       = "aws-ansible-states"
    key          = "epam-ansible-practical-task/VPC/terraform.tfstate"
    region       = "eu-central-1"
    profile      = "second"
  }
}
