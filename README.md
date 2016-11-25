# lambda-dd-diffbot

AWS Lambda function to emit [Diffbot](https://www.diffbot.com/) metrics to [Datadog](https://app.datadoghq.com/).

## Usage

```
git clone git@github.com:takus/lambda-dd-diffbot.git

cd lambda-dd-diffbot

# configure
cp .envrc.template .envrc
vi .envrc

# create aws lambda function
zip lambda_function.zip lambda_function.py
cd terraform/aws_lambda_function
terraform plan
terraform apply

# create datadog monitor
cd terraform/datadog_monitor
terraform plan
terraform apply
```

## Development

```
$ pip install python-lambda-local
$ python-lambda-local -f lambda_handler lambda_function.py event.json
```
