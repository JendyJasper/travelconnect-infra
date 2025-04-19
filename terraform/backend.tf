terraform {
  backend "s3" {
    bucket         = "travelconnect-terraform-state"
    key            = "state/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "travelconnect-terraform-locks"
  }
}