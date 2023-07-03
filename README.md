# Example Platform engineering repo for building serverless infra
A terraform repository that allows for self-service via code for developers to create a serverless AWS API that uses a single API gateway with lambda functions at various endpoints. It supports authorization via cognito user pools and by default supports python3.10 endpoints.

## A hands-on introduction to Platform engineeringA Practical Introduction to Platform Engineering: 
Follow along here: 

## Getting started
1. Clone `git clone https://github.com/SeanOverton/example-platform-eng-serverless-infra.git`

2. Create an AWS user. Create an Access Key credentials for this user. Add AWS secrets to environment variables.
```
AWS_ACCESS_KEY
AWS_SECRET_ACCESS_KEY
```

3. Create S3 bucket and configure tfstate bucket in `./main.tf`

4. Configure AWS CLI credentials locally and run `terraform init` to initialise terraform backend state file in the S3 bucket.

## Creating/deploying a lambda
1. **Infra code:** Add endpoints to `./config.tfvars` like so:
```
lambda_functions = {
  + helloworld = {
    + function_name   = "helloworld"
    + auth_required   = false
    + endpoint_method = "GET"
  + },
}

cognito_user_arns = []

stage_name = "default"
```

2. **Application code:** Add new folder and file for application code in `./lambas/<function_name>/lambda_function.py`

Example helloworld python3.10 lambda:
```
import json

def respond(err, res=None):
    return {
        'statusCode': '400' if err else '200',
        'body': err.message if err else json.dumps(res),
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin' : '*',
        },
    }

def lambda_handler(event, context):
    return respond(None, "Helloworld")
```

