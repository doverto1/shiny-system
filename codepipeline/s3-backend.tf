terraform {
  backend "s3" {
    bucket = ""
    key    = "global/codepipeline/terraform.tfstate"
    region = "us-west-2"

    dynamodb_table = ""
    encrypt        = true
  }
}
