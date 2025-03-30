# Create a Security Group for the RDS instance
resource "aws_security_group" "db_sg" {
  name        = "notification-db-sg"
  description = "Allow access to RDS from within VPC"

  # Allow access to PostgreSQL (default port 5432)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Allows access from your VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "notification_db" {
  db_name                = "notificationdb"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = "db_admin"
  password               = "devopspassword"
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}
