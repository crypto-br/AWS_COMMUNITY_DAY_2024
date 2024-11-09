# CODEBUILD ROLE DATA
data "aws_iam_policy_document" "codebuild_trust_policy" {
  statement {
    sid     = "Trust"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

# CODEBUILD POLICY DATA
data "aws_iam_policy_document" "codebuild_policy" {
  statement {
    sid = "S3"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]
    resources = ["*"]
  }
  statement {
    sid       = "codepipeline"
    actions   = ["codepipeline:*"]
    resources = ["*"]
  }
  statement {
    sid       = "codebuild"
    actions   = ["codebuild:*"]
    resources = ["*"]
  }
  statement {
    sid       = "codestarconnections"
    actions   = ["codestar-connections:*"]
    resources = ["*"]
  }
  statement {
    sid       = "codeconnections"
    actions   = ["codeconnections:*"]
    resources = ["*"]
  }
  statement {
    sid       = "codegurusecurity"
    actions   = ["codeguru-security:*"]
    resources = ["*"]
  }
  statement {
    sid = "logs"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

# CREATE CODEBUILD ROLE AND ATTACH POLICY TO IT
resource "aws_iam_role" "codebuild_role" {
  name               = "AWS_NAME_SAST_ROLE"
  assume_role_policy = data.aws_iam_policy_document.codebuild_trust_policy.json
}

resource "aws_iam_policy" "codebuild_policy" {
  name        = "AWS_NAME_SAST_POLICY"
  path        = "/"
  description = "AWS_COMMUNITY_DAY_SAST POLICY"
  policy      = data.aws_iam_policy_document.codebuild_policy.json
}

resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
  policy_arn = aws_iam_policy.codebuild_policy.arn
  role       = aws_iam_role.codebuild_role.id
}
