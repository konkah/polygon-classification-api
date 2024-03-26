resource "aws_db_instance" "mysql_rds" {
  allocated_storage    = 10
  db_name              = var.RDS_DATABASE
  engine               = "mysql"
  engine_version       = "8.0.36"
  instance_class       = "db.t3.micro"
  username             = var.RDS_USER
  password             = var.RDS_PASSWORD
  # parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = true
  vpc_security_group_ids = [ aws_security_group.mysql_rds_security.id ]
}

output "rds_endpoint" {
  value = "${aws_db_instance.mysql_rds.endpoint}"
}

resource "aws_security_group" "mysql_rds_security" {
  name = "mysql-rds-security"

  ingress {
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}
