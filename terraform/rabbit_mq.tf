# aka. RabbitMQ
resource "aws_security_group" "notification_mq_sg" {
  name        = "notification-mq-sg"
  description = "Security group for MQ broker"
  vpc_id      = aws_vpc.notification_vpc.id

  ingress {
    from_port   = 5672
    to_port     = 5672
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

resource "aws_mq_broker" "notification_mq" {
  broker_name                = "notification-mq"
  engine_type                = "RabbitMQ"
  engine_version             = "3.13"
  host_instance_type         = "mq.t3.micro"
  publicly_accessible        = false
  auto_minor_version_upgrade = true
  security_groups            = [aws_security_group.notification_mq_sg.id]
  user {
    username = "mq_admin"
    password = "devopspassword"
  }
}