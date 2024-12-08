# backend "s3" {
#   bucket               = "surepay-tfstate"
#   workspace_key_prefix = "surepay-ecs"
#   key                  = "surepay-ecs"
#   region               = "eu-west-1"
#   dynamodb_table       = "surepay-tfstate-lock"
#   encrypt              = true
# }