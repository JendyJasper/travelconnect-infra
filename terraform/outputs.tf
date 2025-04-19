output "cognito_user_pool_id" {
  description = "ID of the Cognito User Pool"
  value       = module.cognito.user_pool_id
}

output "cognito_flask_client_id" {
  description = "Client ID for Flask app"
  value       = module.cognito.flask_client_id
}

output "cognito_react_client_id" {
  description = "Client ID for React app"
  value       = module.cognito.react_client_id
}