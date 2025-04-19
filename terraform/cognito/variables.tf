variable "user_pool_name" {
  description = "Name of the Cognito User Pool"
  type        = string
  default     = "travelconnect-users"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "google_client_id" {
  description = "Google OAuth client ID"
  type        = string
  sensitive   = true
}

variable "google_client_secret" {
  description = "Google OAuth client secret"
  type        = string
  sensitive   = true
}

variable "facebook_client_id" {
  description = "Facebook OAuth client ID"
  type        = string
  sensitive   = true
}

variable "facebook_client_secret" {
  description = "Facebook OAuth client secret"
  type        = string
  sensitive   = true
}