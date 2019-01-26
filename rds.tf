variable "rds_username" {}
variable "rds_password" {}


resource "aws_db_instance" "luncherdb" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "10.5"
  instance_class       = "db.t2.micro"
  name                 = "luncherdb"
  skip_final_snapshot = true
  username             = "${var.rds_username}"
  password             = "${var.rds_password}"
}

output "rds_host"{
  value="${aws_db_instance.luncherdb.address}"
}