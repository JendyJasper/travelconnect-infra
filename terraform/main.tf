provider "aws" {
  region = var.aws_region
}

# Retrieve secrets from AWS Secrets Manager
data "aws_secretsmanager_secret_version" "facebook_client_id" {
  secret_id = "travelconnect/facebook_client_clientid"
}

data "aws_secretsmanager_secret_version" "facebook_client_secret" {
  secret_id = "travelconnect/facebook_client_secret"
}

data "aws_secretsmanager_secret_version" "google_client_id" {
  secret_id = "travelconnect/google_client_clientid"
}

data "aws_secretsmanager_secret_version" "google_client_secret" {
  secret_id = "travelconnect/google_client_secret"
}

module "cognito" {
  source = "./cognito"

  user_pool_name         = var.user_pool_name
  aws_region             = var.aws_region
  google_client_id       = data.aws_secretsmanager_secret_version.google_client_id.secret_string
  google_client_secret   = data.aws_secretsmanager_secret_version.google_client_secret.secret_string
  facebook_client_id     = data.aws_secretsmanager_secret_version.facebook_client_id.secret_string
  facebook_client_secret = data.aws_secretsmanager_secret_version.facebook_client_secret.secret_string
}