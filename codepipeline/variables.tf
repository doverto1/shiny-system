variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "admin_role" {
  type = string
}

variable "full_repo_id" {
  type = string
}

variable "codepipeline_terraform_bucket" {
  type = string
}

variable "tf_version" {
  type = string
}
