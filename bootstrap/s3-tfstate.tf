resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name

  #Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_block" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true //Block public access to buckets and objects granted through new access control lists (ACLs)
  ignore_public_acls      = true //Block public access to buckets and objects granted through any access control lists (ACLs)
  block_public_policy     = true //Block public access to buckets and objects granted through new public bucket or access point policies
  restrict_public_buckets = true //Block public and cross-account access to buckets and objects through any public bucket or access point policies

}

