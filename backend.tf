# backend "s3" {
#   bucket               = "surepay-tfstate"
#   workspace_key_prefix = "canary-eks-ghactions"
#   key                  = "canary-eks-ghactions"
#   region               = "us-east-1"
#   dynamodb_table       = "surepay-tfstate-lock"
#   encrypt              = true
# }