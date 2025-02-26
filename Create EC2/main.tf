provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_site" {
  ami           = "ami-05b10e08d247fb927"
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello World</h1>" > /var/www/html/index.html
              EOF    

  security_groups = [aws_security_group.test_page.name]

  tags = {
    Name = "Test Instance"
  }
}

resource "aws_security_group" "test_page" {
  name        = "test_page"
  description = "Permite SSH y HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}