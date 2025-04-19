variable "aws_region" {
  type        = string
  default     = "ap-southeast-1"
  description = "AWS region"
}

variable "user_pool_name" {
  type        = string
  default     = "travelconnect-user-pool"
  description = "Name of the Cognito User Pool"
}