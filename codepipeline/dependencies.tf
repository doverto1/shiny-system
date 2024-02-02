resource "aws_s3_bucket" "codepipeline_terrafrom_s3_bucket" {
  bucket = var.codepipeline_terraform_bucket
}

resource "aws_cloudwatch_log_group" "codebuild_terraform_pipeline" {
  name = "codebuild/terraform_pipeline"
}
