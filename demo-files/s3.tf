variable "luncherapi_packagename" {}
variable "luncherapi_localpath" {}
variable "lambda_packagename" {}
variable "lambda_localpath" {}


#
# Create S3 Bucket in AWS
#
resource "aws_s3_bucket" "deploy_bucket" {
  bucket = "swi-luncher-deploy"
  acl = "private"
  force_destroy = true
}


resource "aws_iam_user" "write_user" {
    name = "s3-write-user"
    force_destroy = true
}

resource "aws_iam_user" "read_user" {
    name = "s3-read-user"
    force_destroy = true
}

resource "aws_iam_access_key" "write_user" {
    user = "${aws_iam_user.write_user.name}"
}

resource "aws_iam_access_key" "read_user" {
    user = "${aws_iam_user.read_user.name}"
}

data "aws_iam_policy_document" "write-user" {
  statement {
    effect = "Allow"
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.deploy_bucket.id}", "arn:aws:s3:::${aws_s3_bucket.deploy_bucket.id}/*"]
  }
}

data "aws_iam_policy_document" "read-user" {
  statement {
    effect = "Allow"
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.deploy_bucket.id}", "arn:aws:s3:::${aws_s3_bucket.deploy_bucket.id}/*"]
  }
}

resource "aws_iam_user_policy" "write_policy" {
  name = "write-policy"
  user = "${aws_iam_user.write_user.name}"
  policy = "${data.aws_iam_policy_document.write-user.json}"
}


resource "aws_iam_user_policy" "read_policy" {
  name = "read-policy"
  user = "${aws_iam_user.read_user.name}"
  policy = "${data.aws_iam_policy_document.read-user.json}"
}

resource "aws_s3_bucket_object" "lambda_package" {
  bucket = "${aws_s3_bucket.deploy_bucket.id}"
  key    = "lambda/${var.lambda_packagename}"
  source = "${var.lambda_localpath}/${var.lambda_packagename}"
}

resource "aws_s3_bucket_object" "luncherapi_package" {
  bucket = "${aws_s3_bucket.deploy_bucket.id}"
  key    = "api/${var.luncherapi_packagename}"
  source = "${var.luncherapi_localpath}/${var.luncherapi_packagename}"
}

output "write_user_id" {
    value = "${aws_iam_access_key.write_user.id}"
}

output "write_user_secret" {
    value = "${aws_iam_access_key.write_user.secret}"
}


