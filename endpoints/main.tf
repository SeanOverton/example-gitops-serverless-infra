data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "./lambdas/${var.function_name}/lambda_function.py"
  output_path = "${var.function_name}/lambda_function.zip"
}

resource "aws_lambda_function" "lambda_function" {
  function_name = var.function_name

  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"

  handler = "lambda_function.lambda_handler"
  runtime = "python3.10"

  filename = data.archive_file.lambda_zip.output_path

  role = aws_iam_role.lambda_role.arn
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.function_name}_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
} 

# AWS Policy to enable loggging to cloudwatch in lambda
data "aws_iam_policy_document" "lambda_policy_doc" {
  statement {
    sid = "AllowInvokingLambdas"
    effect = "Allow"

    resources = [
      "arn:aws:lambda:*:*:function:*"
    ]

    actions = [
      "lambda:InvokeFunction"
    ]
  }

  statement {
    sid = "AllowCreatingLogGroups"
    effect = "Allow"

    resources = [
      "arn:aws:logs:*:*:*"
    ]

    actions = [
      "logs:CreateLogGroup"
    ]
  }

  statement {
    sid = "AllowWritingLogs"
    effect = "Allow"

    resources = [
      "arn:aws:logs:*:*:log-group:/aws/lambda/*:*"
    ]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }

  statement {
    sid = "AllowDynamoDBAccess"
    effect = "Allow"

    resources = [
      "*"
    ]

    actions = [
      "dynamodb:*",
    ]
  }
}

resource "aws_iam_policy" "lambda_iam_policy" {
  name = "${var.function_name}_lambda_iam_policy"
  policy = data.aws_iam_policy_document.lambda_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_iam_policy.arn
  role = aws_iam_role.lambda_role.name
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = var.api_gateway_id
  parent_id   = var.api_gateway_root_id 
  path_part   = var.function_name
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = var.api_gateway_id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = var.endpoint_method
  authorization = var.auth_required ? "COGNITO_USER_POOLS" : "NONE"
  authorizer_id = var.auth_required ? var.authorizer_id : null
}

# connects api_gateway to lambda
resource "aws_api_gateway_integration" "lambda_integration_proxy" {
  rest_api_id = var.api_gateway_id 
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method

  # this must be POST for integration
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

# Allows API gateway to actually trigger lambda
resource "aws_lambda_permission" "allow_api" {
  statement_id  = "AllowAPIgatewayInvokation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
}