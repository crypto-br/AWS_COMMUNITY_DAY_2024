# CREATE BUILD PROJECT FOR AWS COMMUNIT DAY BRASIL GO - 2024
resource "aws_codebuild_project" "devops-build" {
  name = "AWS_COMMUNITY_DAY_SAST"
  description = "AWS_COMMUNITY_DAY_SAST with Amazon CodeGuru"
  service_role = aws_iam_role.codebuild_role.arn
  build_timeout = "10"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "public.ecr.aws/l6c8c5q3/codegurusecurity-actions-public:latest"
    type = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = false
  }

  logs_config {
    cloudwatch_logs {
      group_name = "AWS_COMMUNITY_DAY_SAST_BUILD_LOGS"
    }

    s3_logs {
      status = "DISABLED"
    }
  }

  source {
    buildspec = "buildspec.yml"
    location = "https://github.com/crypto-br/AWS_COMMUNITY_DAY_2024.git"
    type = "GITHUB"
  }
}