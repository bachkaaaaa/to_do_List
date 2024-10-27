provider "aws" {
  region = "eu-west-3"  # Replace with your preferred region
}


resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
 #"Public" subnet creation
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public"
  }
}

#"Private" subnet creation
resource "aws_subnet" "private_subnetA" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-3a" 


  tags = {
    Name = "private"
  }
}
resource "aws_subnet" "private_subnetB" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-3b" 


  tags = {
    Name = "private"
  }
}



#Security group for Spring boot
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2_security_group"
  description = "Allow HTTP/HTTPS and SSH traffic"
  vpc_id      = aws_vpc.main.id
#inbound
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
#inbound
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
#inbound
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

#outbound
#any
#any
#any
#any
  egress {
    from_port   = 0	
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_security_group"
  }
}

# Security group for RDS
resource "aws_security_group" "rds_security_group" {
  name        = "rds_security_group"
  description = "Allow EC2 instances to connect to RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.ec2_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds_security_group"
  }
}



#"Public"subnet Config
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}



resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
#route{ cidr_block="10.0.0.0/16" gateway_id=local} its implicilty created
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_route" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

#creation of ec2 for spring project
resource "aws_instance" "app_instance" {
 
 ami           ="ami-0f209d0bb2c44ea6c"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
    iam_instance_profile = data.aws_iam_role.ec2_role.name

  tags = {
    Name = "springboot-app"
  }
}
#creation rds(relational DB service)instance 
resource "aws_db_instance" "postgresql" {
  engine            = "postgres"
  instance_class    = "db.t2.micro"
  allocated_storage = 20
  username          = "admin"
  password          = "admin_password"
  db_name	    = "mydb"
  multi_az          = true
  storage_encrypted = true
  db_subnet_group_name = aws_db_subnet_group.main.id

  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  tags = {
    Name = "rds_postgresql"
  }
}
#rds used so the same instance can be used in different subnets
resource "aws_db_subnet_group" "main" {
  name       = "main_subnet_group"
  subnet_ids = [aws_subnet.private_subnetA.id,aws_subnet.private_subnetB.id]

  tags = {
    Name = "main_subnet_group"
  }
}


output "db_endpoint" {
  value       = aws_db_instance.postgresql.endpoint
  description = "The endpoint of the RDS instance"
}

data "aws_iam_role" "ec2_role" {
  name = "forEC2"
}
