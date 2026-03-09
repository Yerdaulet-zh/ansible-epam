terraform {
  backend "s3" {
    bucket       = "aws-ansible-states"
    key          = "epam-ansible-practical-task/VPC/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
    profile      = "second"
  }
}
