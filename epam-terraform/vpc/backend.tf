terraform {
  backend "s3" {
    bucket       = "aws-terrafrom-states-files"
    key          = "epam-ansible-practical-task/VPC/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
    profile      = "second"
  }
}
