# key pair for ec2
resource "aws_key_pair" "my-key" {
  key_name   = "terra-key"
  public_key = file("terra-key.pub")
}

# VPC for EC2
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# AWS Security Group
resource "aws_security_group" "my_sg" {
  name        = "mysg-ec2"
  description = "Allow SSH and HTTPS traffic"
  vpc_id      = aws_default_vpc.default.id

  # ✅ Corrected Ingress Rule
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ✅ Corrected Egress Rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "My Security Group"
  }
}


# AWS EC2 Instance
resource "aws_instance" "my_ec2" {
  ami                    = "ami-0e35ddab05955cf57"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.my-key.key_name
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }

  tags = {
    Name = "maccotech-aws"
  }
}
#