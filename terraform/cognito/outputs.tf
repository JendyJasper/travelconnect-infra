output "user_pool_id" {
  description = "ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.travelconnect_users.id
}

output "flask_client_id" {
  description = "Client ID for Flask app"
  value       = aws_cognito_user_pool_client.flask_client.id
}

output "react_client_id" {
  description = "Client ID for React app"
  value       = aws_cognito_user_pool_client.react_client.id
}