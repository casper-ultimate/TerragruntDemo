terraform {
  source = "../../..//modules/ec2"
}

inputs = {
  instance_type = "t2.micro"
  instance_name = "example-server-dev"
}