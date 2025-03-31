#####provider , region , version & profile details #####
provider "aws" {
  region  = var.region-name
  profile = var.profile-name
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.88"
    }
  }
}

#####CReating VPC resource######

resource "aws_vpc" "newvpcname" {
  cidr_block           = var.vpccidr
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name        = var.vpc-name
    Description = "DEV env VPC for DEV resources"
    Team        = "DevOps"
  }
}

######Create IGW  ######
resource "aws_internet_gateway" "new-igw" {
  vpc_id = aws_vpc.newvpcname.id
  tags = {
    Name = "${var.vpc-name}-internet-gateway"
  }
}

######Attach IGW to VPC####
#resource "aws_internet_gateway_attachment" "igw-attachment" {
#  internet_gateway_id = aws_internet_gateway.new-igw.id
#  vpc_id              = aws_vpc.newvpcname.id
#}


###public subnets provision####

resource "aws_subnet" "pub-subnet-1a" {
  vpc_id                  = aws_vpc.newvpcname.id
  cidr_block              = var.pub-sub-1a-cidr
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.vpc-name}-public-subnet-1a"
  }
}


resource "aws_subnet" "pub-subnet-1b" {
  vpc_id                  = aws_vpc.newvpcname.id
  cidr_block              = var.pub-sub-1b-cidr
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.vpc-name}-public-subnet-1b"
  }
}


resource "aws_subnet" "pub-subnet-1c" {
  vpc_id                  = aws_vpc.newvpcname.id
  cidr_block              = var.pub-sub-1c-cidr
  availability_zone       = "ap-south-1c"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.vpc-name}-public-subnet-1c"
  }
}


###private subnets provision####

resource "aws_subnet" "pri-subnet-1a" {
  vpc_id            = aws_vpc.newvpcname.id
  cidr_block        = var.pri-sub-1a-cidr
  availability_zone = "ap-south-1a"
  tags = {
    Name = "${var.vpc-name}-private-subnet-1a"
  }
}


resource "aws_subnet" "pri-subnet-1b" {
  vpc_id            = aws_vpc.newvpcname.id
  cidr_block        = var.pri-sub-1b-cidr
  availability_zone = "ap-south-1b"
  tags = {
    Name = "${var.vpc-name}-private-subnet-1b"
  }
}


resource "aws_subnet" "pri-subnet-1c" {
  vpc_id            = aws_vpc.newvpcname.id
  cidr_block        = var.pri-sub-1c-cidr
  availability_zone = "ap-south-1c"
  tags = {
    Name = "${var.vpc-name}-private-subnet-1c"
  }
}

######Create public route table#######
resource "aws_route_table" "pub-route-table" {
  vpc_id = aws_vpc.newvpcname.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.new-igw.id
  }
  tags = {
    Name = "${var.vpc-name}-public-route-table"
  }
}

########Create private route table###
resource "aws_route_table" "pri-route-table" {
  vpc_id = aws_vpc.newvpcname.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.new-vpc-nat.id
  }
  tags = {
    Name = "${var.vpc-name}-private-route-table"
  }
}

#####Create EIP ###
resource "aws_eip" "new-vpc-eip" {
  domain = "vpc"
  tags = {
    Name = "${var.vpc-name}-elastic-ip"
  }
}

####Create NAT Gateway####
resource "aws_nat_gateway" "new-vpc-nat" {
  allocation_id = aws_eip.new-vpc-eip.id
  subnet_id     = aws_subnet.pub-subnet-1a.id
  tags = {
    Name = "${var.vpc-name}-nat-gateway"
  }
}

####Associate public subnet 1a to public route table###
resource "aws_route_table_association" "pub-subnet-1a-to-route-table-association" {
  subnet_id      = aws_subnet.pub-subnet-1a.id
  route_table_id = aws_route_table.pub-route-table.id
}

####Associate public subnet 1b to public route table###
resource "aws_route_table_association" "pub-subnet-1b-to-route-table-association" {
  subnet_id      = aws_subnet.pub-subnet-1b.id
  route_table_id = aws_route_table.pub-route-table.id
}

####Associate public subnet 1c to public route table###
resource "aws_route_table_association" "pub-subnet-1c-to-route-table-association" {
  subnet_id      = aws_subnet.pub-subnet-1c.id
  route_table_id = aws_route_table.pub-route-table.id
}


####Associate private subnet 1a to private route table###
resource "aws_route_table_association" "pri-subnet-1a-to-route-table-association" {
  subnet_id      = aws_subnet.pri-subnet-1a.id
  route_table_id = aws_route_table.pri-route-table.id
}

####Associate private subnet 1b to private route table###
resource "aws_route_table_association" "pri-subnet-1b-to-route-table-association" {
  subnet_id      = aws_subnet.pri-subnet-1b.id
  route_table_id = aws_route_table.pri-route-table.id
}

####Associate private subnet 1c to private route table###
resource "aws_route_table_association" "pri-subnet-1c-to-route-table-association" {
  subnet_id      = aws_subnet.pri-subnet-1c.id
  route_table_id = aws_route_table.pri-route-table.id
}

###Create public NACL###
resource "aws_network_acl" "pub-nacl" {
  vpc_id = aws_vpc.newvpcname.id
  tags = {
    Name = "${var.vpc-name}-public-nacl"
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}



###Create private NACL###
resource "aws_network_acl" "pri-nacl" {
  vpc_id = aws_vpc.newvpcname.id
  tags = {
    Name = "${var.vpc-name}-private-nacl"
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}


####Associate public subnet 1a to public NACL###
resource "aws_network_acl_association" "pub-sub-1a-to-nacl-association" {
  network_acl_id = aws_network_acl.pub-nacl.id
  subnet_id      = aws_subnet.pub-subnet-1a.id
}

####Associate public subnet 1b to public NACL###
resource "aws_network_acl_association" "pub-sub-1b-to-nacl-association" {
  network_acl_id = aws_network_acl.pub-nacl.id
  subnet_id      = aws_subnet.pub-subnet-1b.id
}

####Associate public subnet 1c to public NACL###
resource "aws_network_acl_association" "pub-sub-1c-to-nacl-association" {
  network_acl_id = aws_network_acl.pub-nacl.id
  subnet_id      = aws_subnet.pub-subnet-1c.id
}




####Associate private subnet 1a to private NACL###
resource "aws_network_acl_association" "pri-sub-1a-to-nacl-association" {
  network_acl_id = aws_network_acl.pri-nacl.id
  subnet_id      = aws_subnet.pri-subnet-1a.id
}

####Associate private subnet 1b to private NACL###
resource "aws_network_acl_association" "pri-sub-1b-to-nacl-association" {
  network_acl_id = aws_network_acl.pri-nacl.id
  subnet_id      = aws_subnet.pri-subnet-1b.id
}

####Associate private subnet 1c to private NACL###
resource "aws_network_acl_association" "pri-sub-1c-to-nacl-association" {
  network_acl_id = aws_network_acl.pri-nacl.id
  subnet_id      = aws_subnet.pri-subnet-1c.id
}


######Create security Group for public EC2 servers###
resource "aws_security_group" "sg-for-ec2" {
  vpc_id      = aws_vpc.newvpcname.id
  description = "This SG for public EC2 servers access"
  tags = {
    Name = "${var.vpc-name}-ec2-public-sg"
  }

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


######Create security Group for public ALB ###
resource "aws_security_group" "alb-pub-sg" {
  vpc_id      = aws_vpc.newvpcname.id
  name        = "${var.vpc-name}-alb-public-security-group"
  description = "This SG for public ALB access"
  tags = {
    Name = "${var.vpc-name}-alb-public-sg"
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


#######Provision public EC2 server in DEV VPC###
resource "aws_instance" "new-server" {
  ami                    = var.imageid
  instance_type          = var.ec2-instance-type
  key_name               = var.ec2-pem-key
  subnet_id              = aws_subnet.pub-subnet-1a.id
  vpc_security_group_ids = [aws_security_group.sg-for-ec2.id]
  user_data              = <<-EOF
        #!/bin/bash
        sudo apt update -y
        sudo apt install nginx -y
        sudo systemctl enable nginx.service -y
  EOF
  tags = {
    Name = "${var.environment}-app-server1"
  }
}
