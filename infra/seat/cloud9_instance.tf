data "aws_vpc" "main" {
  default = true
}

resource "aws_cloud9_environment_ec2" "cloud_9_env" {
  instance_type = "t3.micro"
  name          = var.student_id
}