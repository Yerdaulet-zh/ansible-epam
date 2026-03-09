data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "aws-terrafrom-states"
    key    = "epam-terraform-practical-task/VPC/terraform.tfstate"
    region = "eu-south-1"
    profile = "default"
  }
}
