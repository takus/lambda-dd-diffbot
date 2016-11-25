variable "function_name" {
	default = "dd-diffbot"
}

variable "function_description" {
	default = "Emit Diffbot metrics to Datadog"
}

variable "datadog_api_key" {
	description = "Datadog API key"
}

variable "diffbot_token" {
	description = "Diffbot API token"
}

variable "function_role_arn" {
	description = "AWS Lambda execution role ARN"
}

variable "function_key_arn" {
	description = "AWS KMS key ARN"
}

