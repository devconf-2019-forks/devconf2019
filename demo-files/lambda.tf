resource "aws_lambda_function" "clustering_lambda" {
  role             = "${aws_iam_role.clustering_lambda_role.arn}"
  handler          = "solarwinds.Clustering::handleRequest"
  function_name = "clusteringlambda"
  s3_key = "lambda/${var.lambda_packagename}"
  s3_bucket = "${aws_s3_bucket.deploy_bucket.id}"
  runtime          = "java8"
  timeout = 20

  vpc_config {
    subnet_ids = ["${data.aws_subnet_ids.default.ids}"]
    security_group_ids = ["${aws_default_security_group.default.id}"]
  }

  environment {
    variables = {
      RDS_HOST = "${aws_db_instance.luncherdb.address}"
      RDS_DB = "${aws_db_instance.luncherdb.name}"
      RDS_USER = "${var.rds_username}"
      RDS_PASS = "${var.rds_password}"
    }
  }
}


data "aws_iam_policy" "vpc_access" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "aws_iam_policy_document" "clustering" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}


resource "aws_iam_role" "clustering_lambda_role" {
  name = "clustering_lambda_role"
  assume_role_policy = "${data.aws_iam_policy_document.clustering.json}"
}

resource "aws_iam_role_policy_attachment" "vpc" {
  policy_arn = "${data.aws_iam_policy.vpc_access.arn}"
  role = "${aws_iam_role.clustering_lambda_role.name}"
}


data "aws_subnet_ids" "default" {
  vpc_id = "${aws_default_vpc.default.id}"
}

resource "aws_cloudwatch_event_rule" "every1minute" {
  name        = "every_1_minute_trigger"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "clustering_lambda" {
  rule      = "${aws_cloudwatch_event_rule.every1minute.name}"
  target_id = "LambdaExec"
  arn       = "${aws_lambda_function.clustering_lambda.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.clustering_lambda.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.every1minute.arn}"
}


