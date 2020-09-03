provider "aws" {
  region     = "us-east-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

data "aws_ami" "centos" {
  owners      = ["285398391915"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ami-centos-7-1.11.3-00-1537830214*"]
  }
}
resource "aws_key_pair" "ssh_user" {
  key_name   = "ssh-user-key"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_security_group" "allow" {
  name        = "allow"
  description = "Allow traffic"
  vpc_id      = "vpc-eadb7781"
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow"
  }
}

resource "aws_instance" "centos_wm" {
  ami             = data.aws_ami.centos.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.ssh_user.id
  security_groups = [aws_security_group.allow.name]
  tags = {
    Name = "test"
  }

  provisioner "local-exec" {
    command     = "sleep 30 && ansible-playbook -u centos -i '${self.public_ip},' --private-key ~/.ssh/id_rsa playbook.yaml"
    working_dir = "./ansible"
  }

}
