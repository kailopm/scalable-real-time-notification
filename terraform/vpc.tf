resource "aws_vpc" "notification_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "notification_subnet_1" {
  vpc_id                  = aws_vpc.notification_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-1a" # Make sure to choose two different AZs for high availability
  map_public_ip_on_launch = true
}

resource "aws_subnet" "notification_subnet_2" {
  vpc_id                  = aws_vpc.notification_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-southeast-1b" # Choose a different AZ
  map_public_ip_on_launch = true
}
