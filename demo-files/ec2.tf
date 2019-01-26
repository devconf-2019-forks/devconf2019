variable "private_key_path" {}
variable "localhost_public_key" {}

resource "aws_instance" "luncherapi" {
  ami           = "ami-012fd5eb46f56731f"
  instance_type = "t2.micro"
  key_name        = "${aws_key_pair.default.key_name}"

  provisioner "remote-exec" {
    inline = [
      "mkdir /home/ubuntu/.aws"
    ]
  }

  provisioner "file" {
    content = <<EOF
[default]
aws_access_key_id=${aws_iam_access_key.read_user.id}
aws_secret_access_key=${aws_iam_access_key.read_user.secret}
    EOF

    destination = "/home/ubuntu/.aws/credentials"
  }

  connection {
    user        = "ubuntu"
    private_key = "${file(var.private_key_path)}"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y purge unattended-upgrades",
      "sleep 5 && ps -ef | grep apt ",
      "sudo apt-get -qq update && sudo apt-get -qq install -y openjdk-8-jdk-headless awscli",
      "aws s3 cp s3://${aws_s3_bucket.deploy_bucket.id}/api/${var.luncherapi_packagename} .",
      "RDS_HOST=${aws_db_instance.luncherdb.address} RDS_USER=${var.rds_username} RDS_PASS=${var.rds_password} RDS_DB=${aws_db_instance.luncherdb.name} nohup java -jar ${var.luncherapi_packagename} &",
      "sleep 5"
    ]
  }
}

resource "aws_default_security_group" "default" {
  vpc_id="${aws_default_vpc.default.id}"

  ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "default" {
  key_name   = "default-key"
  public_key = "${var.localhost_public_key}"
}

output "luncherapi" {
    value = "${aws_instance.luncherapi.public_dns}"
}

