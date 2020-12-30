resource "aws_codebuild_project" "build_project_website_breaches" {
  name         = "build-webiste-breaches"
  service_role = aws_iam_role.build_project_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:3.0"
    type            = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "website-breach"
      stream_name = "log-stream"
    }
  }
  
  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
}

resource "aws_iam_role" "build_project_role" {
  name = "build-project-role"

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

resource "aws_iam_policy" "build_project_policy" {
  name = "build-project-policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:logs:eu-central-1:237177742741:log-group:website-breach:log-stream:log-stream",
                "arn:aws:logs:eu-central-1:237177742741:log-group:website-breach:log-stream:log-stream:",
                "arn:aws:logs:eu-central-1:237177742741:log-group:website-breach:log-stream:log-stream/*",
                "arn:aws:logs:eu-central-1:237177742741:log-group:website-breach:log-stream:"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::codepipeline-breaches-bucket/*"
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
            "Resource": [
                "arn:aws:codebuild:eu-central-1:237177742741:report-group/website-breach-*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = aws_iam_role.build_project_role.name
  policy_arn = aws_iam_policy.build_project_policy.arn
}