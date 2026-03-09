terraform {
  backend "s3" {
    bucket       = "aws-terrafrom-states"
    key          = "epam-terraform-practical-task/VPC/terraform.tfstate"
    region       = "eu-south-1"
    encrypt      = true
    use_lockfile = true
    profile      = "default"
  }
}
