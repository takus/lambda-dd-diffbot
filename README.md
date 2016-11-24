# lambda-dd-diffbot

AWS Lambda function to emit [Diffbot](https://www.diffbot.com/) metrics to [Datadog](https://app.datadoghq.com/).

## Development

```
$ pip install python-lambda-local
$ python-lambda-local -f lambda_handler lambda_function.py event.json
```
