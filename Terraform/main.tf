provider "aws" {
  region  = "us-east-1"  # Change to your desired region
  profile = "iamadmin-general" 
}

resource "aws_instance" "web_server" {
  count         = 2
  ami           = "ami-0fff1b9a61dec8a5f"  # Replace with your desired AMI ID
  instance_type = "t2.micro"   
  key_name      = "A4L"  # Replace with your key pair name
  
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "WebServer-${count.index}"  # Tag instances uniquely
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

# Output the public IP addresses for each instance
output "public_ips" {
  value = aws_instance.web_server[*].public_ip
}

# Output the instance IDs for each instance
output "instance_ids" {
  value = aws_instance.web_server[*].id
}

# Overwrite Ansible inventory file with the new instance ID every time
resource "local_file" "ansible_inventory" {
  filename = "/Users/dave/repos/AWS-IAC/Ansible/hosts.yml"  # This file is overwritten on every terraform apply
  content  = <<-EOF
[ec2_instances]
%{ for ip in aws_instance.web_server[*].public_ip }
${ip}
%{ endfor }
  EOF
}