provider "aws" {
  region  = "us-east-2"
  profile = "default"
}

resource "aws_instance" "example" {
  ami = "ami-0283a57753b18025b"
  user_data = <<-EOF
        #!/bin/bash
        sudo echo "Hello, World" > index.html
        sudo nohup busybox httpd -f -p 80
        EOF
  instance_type = var.instance_type

  user_data_replace_on_change = true

  tags = {
    Name = var.instance_name
  }
}