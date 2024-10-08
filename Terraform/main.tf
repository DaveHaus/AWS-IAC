provider "aws" {
  region = "us-east-1"  # Change to your desired region
  profile       = "iamadmin-general" 
}

resource "aws_instance" "web_server" {
  ami           = "ami-0fff1b9a61dec8a5f"  # Replace with your desired AMI ID
  instance_type = "t2.micro"   
  key_name     = "A4L"  # Replace with your key pair name
  
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "WebServer"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow inbound traffic for web server"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}

