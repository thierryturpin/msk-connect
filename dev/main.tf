##========================================================================================
##                                                                                      ##
##                                       Providers                                      ##
##                                                                                      ##
##========================================================================================

terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region                  = "eu-central-1"
  allowed_account_ids     = var.allowed_account_ids

  default_tags {
    tags = {
      Created_by  = "Terraform"
      Environment = var.env
      Owner       = var.owner
    }
  }
}
