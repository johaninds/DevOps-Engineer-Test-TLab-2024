provider "aws" {
  region = "us-east-2"
}

resource "aws_security_group" "microsvc-sg" {
  name        = "microsvc-sg"
  description = "Allow SSH and HTTP ports from anywhere"

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
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }


  ingress {
    from_port   = 6443 # Kubernetes API server port
    to_port     = 6443
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

resource "aws_instance" "master" {
  ami                    = "ami-0f30a9c3a48f3fa79"
  instance_type          = "t2.medium"
  key_name               = "tlab-key"
  vpc_security_group_ids = [aws_security_group.microsvc-sg.id]
  tags = {
    Name = "microsvc-master"
  }
  user_data = file("${path.module}/user_data.sh")
}

resource "aws_instance" "worker" {
  ami                    = "ami-0f30a9c3a48f3fa79"
  instance_type          = "t2.micro"
  key_name               = "tlab-key"
  vpc_security_group_ids = [aws_security_group.microsvc-sg.id]
  count                  = 2
  tags = {
    Name = "microsvc-worker-${count.index + 1}"
  }
  user_data = file("${path.module}/user_data.sh")
}

output "master_public_ip" {
  value = aws_instance.master.public_ip
}

output "worker_public_ips" {
  value = aws_instance.worker[*].public_ip
}
