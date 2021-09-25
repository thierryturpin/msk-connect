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
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "tf-turpin"

  default_tags {
    tags = {
      Created_by  = "Terraform"
      Environment = var.env
      Owner       = var.owner
    }
  }
}
