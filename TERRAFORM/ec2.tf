# Create a key pair for EC2 instances
resource "aws_key_pair" "my_key_pair" {
  key_name   = "terraform-key-ec2"
  public_key = file("terraform-key-ec2.pub")
  
}
# create default vpc
resource "aws_default_vpc" "default" {
}
# Create a security group for EC2 instances
resource "aws_security_group" "my_security_group" {
  name        = "terraform-security-group"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_default_vpc.default.id

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

# Create an EC2 instance
resource "aws_instance" "my_ec2_instance" {
  for_each = tomap({
    first-instance = "t3.micro"
    second-instance = "t3.small"
  })
  ami           = var.ec2_instance_ami_id
  instance_type = each.value
  root_block_device {
    volume_size = var.ec2_root_storage_size
    volume_type = "gp3"
  }
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  key_name      = aws_key_pair.my_key_pair.key_name
  security_groups = [aws_security_group.my_security_group.name]

  tags = {
    Name = each.key

  user_data = file("install_nginx.bash")  
  }
}  
