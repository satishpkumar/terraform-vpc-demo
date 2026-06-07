resource "aws_vpc" "main" {

  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "main VPC"
    Description = "The Primary VPC"

  }

}

resource "aws_subnet" "public" {


  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name        = "public subnet 1a"
    Description = "Public subnet under main VPC"
  }
}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "terraform-igw"
  }

}

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id

  }

  tags = {
    Name = "public-route-table"
  }

}

resource "aws_route_table_association" "public" {

  subnet_id = aws_subnet.public.id

  route_table_id = aws_route_table.public.id

}

resource "aws_instance" "web" {

  ami                    = "ami-0685bcc683dadb6b9"

  instance_type          = "t2.micro"

  subnet_id              = aws_subnet.public.id

  associate_public_ip_address = true

  tags = {
    Name = "terraform-vpc-demo-ec2"
  }

}

resource "aws_security_group" "web_sg" {

  name        = "web-sg"

  description = "Allow SSH"

  vpc_id      = aws_vpc.main.id

  ingress {

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
    Name = "web-sg"
  }

}