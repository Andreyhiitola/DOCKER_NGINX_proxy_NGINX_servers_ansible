terraform  {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-bucket-463487226590"
    key    = "welbex_test_task"
    region =  "eu-central-1"
    dynamodb_table = "terraform-lock"
  }
}

# Configure the AWS Provider
provider "aws" {
  region =   "eu-central-1"
}
