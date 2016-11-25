resource "aws_lambda_function" "dd_diffbot" {
    function_name = "${var.function_name}"
	description = "${var.function_description}"

    filename = "../../lambda_function.zip"
    source_code_hash = "${base64sha256(file("../../lambda_function.zip"))}"
	runtime = "python2.7"
    handler = "lambda_function.lambda_handler"
	timeout = 30

	environment {
		variables = {
			DATADOG_API_KEY = "${var.datadog_api_key}"
			DIFFBOT_TOKEN = "${var.diffbot_token}"
		}
	}

    role = "${var.function_role_arn}"
	kms_key_arn = "${var.function_key_arn}"
}

resource "aws_cloudwatch_event_rule" "scheduler" {
  name = "${aws_lambda_function.dd_diffbot.function_name}-scheduler"
  description = "${aws_lambda_function.dd_diffbot.description}"
  schedule_expression = "rate(10 minutes)"
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule = "${aws_cloudwatch_event_rule.scheduler.name}"
  target_id = "InvokeLambda"
  arn = "${aws_lambda_function.dd_diffbot.arn}"
}

resource "aws_cloudwatch_log_group" "lambda" {
  name = "/aws/lambda/${aws_lambda_function.dd_diffbot.function_name}"
  retention_in_days = 14
}
