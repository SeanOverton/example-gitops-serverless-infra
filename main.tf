terraform {
  backend "s3" {
    bucket = "CHANGE THIS-tfstate"
    key    = "terraform.tfstate"
    region = "ap-southeast-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_api_gateway_rest_api" "main_api_gateway" {
  name        = "MainAPI"
  description = "Main API Gateway used that all backend traffic passes through."
}

resource "aws_api_gateway_deployment" "gateway_deployment" {
  depends_on = [module.endpoint]

  rest_api_id = aws_api_gateway_rest_api.main_api_gateway.id

  triggers = {
    redeployment = filesha1("./config.tfvars")
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "gateway_stage" {
  depends_on = [module.endpoint]

  deployment_id = aws_api_gateway_deployment.gateway_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.main_api_gateway.id
  stage_name    = var.stage_name
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name          = "cognito_auth"
  rest_api_id   = aws_api_gateway_rest_api.main_api_gateway.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = var.cognito_user_arns
}

module "endpoint" {
  source              = "./endpoints"
  api_gateway_id      = aws_api_gateway_rest_api.main_api_gateway.id
  api_gateway_root_id = aws_api_gateway_rest_api.main_api_gateway.root_resource_id
  for_each            = var.lambda_functions
  function_name       = each.value.function_name
  auth_required       = each.value.auth_required == null ? false : each.value.auth_required
  endpoint_method     = each.value.endpoint_method == null ? "GET" : each.value.endpoint_method
  authorizer_id       = aws_api_gateway_authorizer.cognito_authorizer.id
}