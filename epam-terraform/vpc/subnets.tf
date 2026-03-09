resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.subnet_public_cidr
  availability_zone       = "${local.region}a"
  map_public_ip_on_launch = true

  tags = {
    Project = "${local.project_name}"
    Name    = "Public Subent"
  }
}

output "public_subnet_id" {
  value = aws_subnet.public.id
  sensitive = true
}
