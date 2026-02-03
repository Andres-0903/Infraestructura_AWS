# # ## Para desconectarse del state remote se debe comentar el cdigo de backend.tf

# terraform {
#   required_version = ">= 1.0.0"

#   backend "s3" {
#     region  = "us-east-1"
#     bucket  = "ejemplouso-env-terraform-state"
#     key     = "terraform.tfstate"
#     profile = ""
#     encrypt = "true"

#     dynamodb_table = "ejemplouso-env-terraform-state-lock"
#   }
# }
