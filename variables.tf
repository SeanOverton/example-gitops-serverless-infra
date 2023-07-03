variable "lambda_functions" {
  type = map(object({
    function_name   = string
    auth_required   = optional(bool)
    endpoint_method = optional(string)
  }))

  description = "List of lambda functions to be created behind a single API gateway."
}

variable "cognito_user_arns" {
  type        = list(string)
  description = "List of cognito user pool ARN's that are to be included in the authorizer for the API Gateway"
}

variable "stage_name" {
  type        = string
  description = "Stage name for deployment of API gateway. This ends up being part of the endpoint URL for the gateway and all lambdas."
}