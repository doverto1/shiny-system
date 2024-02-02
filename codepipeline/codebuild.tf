data "aws_iam_policy" "admin" {
  name = var.admin_role
}



resource "aws_iam_role" "codebuild_terraform_role" {
  name               = "codebuild-terrafrom-service-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild_terraform_policy" {
  name   = "codebuild_terraform_policy"
  role   = aws_iam_role.codebuild_terraform_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "${aws_s3_bucket.codepipeline_terrafrom_s3_bucket.arn}",
                "${aws_s3_bucket.codepipeline_terrafrom_s3_bucket.arn}/*"              
            ],
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:CreateReportGroup",
                "codebuild:CreateReport",
                "codebuild:UpdateReport",
                "codebuild:BatchPutTestCases",
                "codebuild:BatchPutCodeCoverages"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "admin-attach" {
  role       = aws_iam_role.codebuild_terraform_role.name
  policy_arn = data.aws_iam_policy.admin.arn
}
resource "aws_codebuild_project" "terraform" {
  name          = "terraform_resources"
  description   = "Apply terrafrom resource"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_terraform_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    environment_variable {
      name  = "TF_COMMAND"
      value = "plan"
    }
    environment_variable {
      name  = "TF_VERSION"
      value = var.tf_version
    }

  }
  logs_config {
    cloudwatch_logs {
      group_name  = "codepipeline"
      stream_name = "terraform"
    }
  }
  source {
    type                = "CODEPIPELINE"
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    buildspec           = "${path.module}/codepipeline/cicd/terraform_plan.yaml"
  }
}

resource "aws_codebuild_project" "terraform_apply" {
  name          = "terraform_apply"
  description   = "Apply terrafrom resource"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_terraform_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    environment_variable {
      name  = "TF_COMMAND"
      value = "apply"
    }
    environment_variable {
      name  = "TF_VERSION"
      value = var.tf_version
    }

  }
  logs_config {
    cloudwatch_logs {
      group_name  = "codepipeline"
      stream_name = "terraform"
    }
  }
  source {
    type                = "CODEPIPELINE"
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    buildspec           = "${path.module}/codepipeline/cicd/terraform_apply.yaml"
  }
}
