resource "aws_iam_instance_profile" "beanstalk_profile" {
  name = "aws-elasticbeanstalk-ec2-role"
  role = aws_iam_role.beanstalk_role.name
}

resource "aws_iam_role" "beanstalk_role" {
  name = "aws-elasticbeanstalk-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "beanstalk_policy" {
  name = "aws-elasticbeanstalk-ec2-policy"
  role = aws_iam_role.beanstalk_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "BucketAccess"
        Action =  [
          "s3:Get*",
          "s3:List*",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::elasticbeanstalk-*",
          "arn:aws:s3:::elasticbeanstalk-*/*"
        ]
      },
      {
        Sid = "XRayAccess",
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets",
          "xray:GetSamplingStatisticSummaries"
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Sid = "CloudWatchLogsAccess"
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk*"
        ]
      },
      {
        Sid = "ElasticBeanstalkHealthAccess"
        Action = [
          "elasticbeanstalk:PutInstanceStatistics"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:elasticbeanstalk:*:*:application/*",
          "arn:aws:elasticbeanstalk:*:*:environment/*"
        ]
      }
    ]
  })
}
