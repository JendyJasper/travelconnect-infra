resource "aws_cognito_user_pool" "travelconnect_users" {
       name                     = var.user_pool_name
       auto_verified_attributes = ["email"]
       mfa_configuration        = "OPTIONAL"

       password_policy {
         minimum_length                   = 8
         require_lowercase                = true
         require_numbers                  = true
         require_symbols                  = true
         require_uppercase                = true
         temporary_password_validity_days = 7
       }

       schema {
         name                = "email"
         attribute_data_type = "String"
         required            = true
         mutable             = true
         string_attribute_constraints {
           min_length = 1
           max_length = 256
         }
       }

       schema {
         name                = "name"
         attribute_data_type = "String"
         required            = true
         mutable             = true
         string_attribute_constraints {
           min_length = 1
           max_length = 256
         }
       }

       sms_configuration {
         external_id    = "travelconnect-sms-role"
         sns_caller_arn = aws_iam_role.sns_role.arn
       }
     }

     resource "aws_cognito_user_pool_domain" "main" {
       domain       = var.user_pool_name
       user_pool_id = aws_cognito_user_pool.travelconnect_users.id
     }

     resource "aws_cognito_user_pool_client" "flask_client" {
       name                 = "${var.user_pool_name}-flask"
       user_pool_id         = aws_cognito_user_pool.travelconnect_users.id
       generate_secret      = true
       allowed_oauth_flows  = ["code", "implicit"]
       allowed_oauth_scopes = ["email", "openid", "profile"]
       callback_urls = [
         "http://localhost:5000/callback",
         "https://app.travelconnect.vn/callback",
         "https://${aws_cognito_user_pool_domain.main.domain}.auth.${var.aws_region}.amazoncognito.com/oauth2/idpresponse"
       ]
       logout_urls = [
         "http://localhost:5000/logout",
         "https://app.travelconnect.vn/logout",
         "https://${aws_cognito_user_pool_domain.main.domain}.auth.${var.aws_region}.amazoncognito.com/logout"
       ]
       allowed_oauth_flows_user_pool_client = true
       explicit_auth_flows                  = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
       supported_identity_providers         = ["Google", "Facebook"]
     }

     resource "aws_cognito_user_pool_client" "react_client" {
       name                 = "${var.user_pool_name}-react"
       user_pool_id         = aws_cognito_user_pool.travelconnect_users.id
       generate_secret      = false
       allowed_oauth_flows  = ["code", "implicit"]
       allowed_oauth_scopes = ["email", "openid", "profile"]
       callback_urls = [
         "http://localhost:3000/callback",
         "https://app.travelconnect.vn/callback",
         "https://${aws_cognito_user_pool_domain.main.domain}.auth.${var.aws_region}.amazoncognito.com/oauth2/idpresponse"
       ]
       logout_urls = [
         "http://localhost:3000/logout",
         "https://app.travelconnect.vn/logout",
         "https://${aws_cognito_user_pool_domain.main.domain}.auth.${var.aws_region}.amazoncognito.com/logout"
       ]
       allowed_oauth_flows_user_pool_client = true
       explicit_auth_flows                  = ["ALLOW_USER_SRP_AUTH"]
       supported_identity_providers         = ["Google", "Facebook"]
     }

     resource "aws_cognito_identity_provider" "google" {
       user_pool_id  = aws_cognito_user_pool.travelconnect_users.id
       provider_name = "Google"
       provider_type = "Google"

       provider_details = {
         client_id        = var.google_client_id
         client_secret    = var.google_client_secret
         authorize_scopes = "email profile openid"
       }

       attribute_mapping = {
         email    = "email"
         name     = "name"
         username = "sub"
       }
     }

     resource "aws_cognito_identity_provider" "facebook" {
       user_pool_id  = aws_cognito_user_pool.travelconnect_users.id
       provider_name = "Facebook"
       provider_type = "Facebook"

       provider_details = {
         client_id        = var.facebook_client_id
         client_secret    = var.facebook_client_secret
         authorize_scopes = "public_profile,email"
       }

       attribute_mapping = {
         email    = "email"
         name     = "name"
         username = "id"
       }
     }

     resource "aws_iam_role" "sns_role" {
       name = "travelconnect-cognito-sns-role"
       assume_role_policy = jsonencode({
         Version = "2012-10-17"
         Statement = [
           {
             Effect = "Allow"
             Principal = {
               Service = "cognito-idp.amazonaws.com"
             }
             Action = "sts:AssumeRole"
           }
         ]
       })
     }

     resource "aws_iam_role_policy" "sns_policy" {
       name = "travelconnect-cognito-sns-policy"
       role = aws_iam_role.sns_role.id
       policy = jsonencode({
         Version = "2012-10-17"
         Statement = [
           {
             Effect   = "Allow"
             Action   = ["sns:Publish"]
             Resource = "*"
           }
         ]
       })
     }

     resource "aws_ssm_parameter" "travelconnect_cognito_user_pool_id" {
       name  = "/travelconnect/cognito/user_pool_id"
       type  = "String"
       value = aws_cognito_user_pool.travelconnect_users.id
     }

     resource "aws_ssm_parameter" "travelconnect_cognito_flask_client_id" {
       name  = "/travelconnect/cognito/flask_client_id"
       type  = "String"
       value = aws_cognito_user_pool_client.flask_client.id
     }

     resource "aws_ssm_parameter" "travelconnect_cognito_react_client_id" {
       name  = "/travelconnect/cognito/react_client_id"
       type  = "String"
       value = aws_cognito_user_pool_client.react_client.id
     }

     resource "aws_ssm_parameter" "travelconnect_cognito_region" {
       name  = "/travelconnect/cognito/region"
       type  = "String"
       value = var.aws_region
     }

     resource "aws_ssm_parameter" "travelconnect_cognito_user_pool_domain" {
       name  = "/travelconnect/cognito/user_pool_domain"
       type  = "String"
       value = aws_cognito_user_pool_domain.main.domain
     }

     resource "aws_secretsmanager_secret" "flask_client_secret" {
       name = "travelconnect/cognito/flask_client_secrets"
     }

     resource "aws_secretsmanager_secret_version" "flask_client_secret_version" {
       secret_id     = aws_secretsmanager_secret.flask_client_secret.id
       secret_string = aws_cognito_user_pool_client.flask_client.client_secret
     }