provider "aws" {
  region                   = "us-east-1"
  shared_config_files      = ["/home/mohamedmamdouh/.aws/config"]
  shared_credentials_files = ["/home/mohamedmamdouh/.aws/credentials"]
  # profile                  = "paularoot"

}

# terraform {
#   backend "s3" {
#     bucket                  = "lord-25-1-2023"
#     key                     = "terrform.tfstate"
#     region                  = "us-east-1"
#     shared_credentials_file = "/home/mohamedmamdouh/.awscredentials"
#     profile                 = "paularoot"
#     dynamodb_table          = "lord-statelock"
#   }
# }
