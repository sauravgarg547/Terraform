# key pair for ec2

resource "aws_key_pair" "my-key" {
  key_name = "terra-key"
  public_key = file("terra-key.pub")
}

# vpc for ec2

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# Aws Security Group

resource "aws_security_group" "my_sg" {
    name = "mysg-ec2"
    description = "Allow TLS inbound traffic and all outbound traffic"
    vpc_id = aws_default_vpc.default

    #inboud rule

    ingress = {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.my_sg
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  cidr_ipv6         = aws_default_vpc.ipv6_cidr_block
}

resource "aws_vpc_security_group_egress_rule" "my_outbond" {
  security_group_id = aws_security_group.my_sg
  from_port = 0
  to_port = 0
  ip_protocol = "-1"
  cidr_ipv4 = "::/0"
}

# aws ec2 instance

resource "aws_instance" "my_ec2" {
  key_name = aws_key_pair.my-key.key_name
  instance_type = "t2.micro"
  security_groups = aws_security_group.my_sg.name
  ami = "ami-0e35ddab05955cf57"
}