provider "aws" {
  region = "us-east-1"  # Change to your desired region
}

resource "aws_db_instance" "postgres_instance" {
  identifier           = "postgres-db"
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "14"    # Specify desired PostgreSQL version
  instance_class       = "db.t3.micro"
  db_name              = "fastfood"
  username             = "postgres"   # Master username
  password             = "postgres"   # Master password
  parameter_group_name = "default.postgres14"
  publicly_accessible  = true      # Make it publicly accessible
  skip_final_snapshot  = true      # Skip final snapshot on delete
  vpc_security_group_ids = [aws_security_group.rds_sg.id]  # Link to security group
}

# Security group to allow inbound traffic on PostgreSQL port
resource "aws_security_group" "rds_sg" {
  name        = "rds_public_access_sg"
  description = "Allow inbound access to PostgreSQL"

  ingress {
    from_port   = 5432  # PostgreSQL default port
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to the public (be careful with this in production)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "db_endpoint" {
  value = aws_db_instance.postgres_instance.endpoint
}