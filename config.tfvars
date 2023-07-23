lambda_functions = {
  helloworld = {
    function_name   = "helloworld"
    auth_required   = false
    endpoint_method = "GET"
  }
}

cognito_user_arns = []

stage_name = "default"