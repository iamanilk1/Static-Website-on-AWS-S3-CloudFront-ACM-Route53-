# Optional: configure remote state backend (uncomment and fill to use)
# terraform {
#   backend "s3" {
#     bucket         = "<your-tfstate-bucket>"
#     key            = "scenario3/dev/terraform.tfstate"
#     region         = "<region>"
#     dynamodb_table = "<your-lock-table>"
#     encrypt        = true
#   }
# }
