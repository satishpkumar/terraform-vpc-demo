resource "aws_vpc" "main"{

cidr_block = "10.0.0.0/16"

tags = {
Name  = "main VPC"
Description = "The Primary VPC"

}

}

resource "aws_subnet" "public"{


vpc_id      = aws_vpc.main.id
cidr_block ="10.0.1.0/24"
availability_zone = "ap-south-1a"

tags={
Name = "public subnet 1a"
Description = "Public subnet under main VPC"
}
}