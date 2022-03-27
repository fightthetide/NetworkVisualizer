# Create elastic beanstalk application
 
resource "aws_elastic_beanstalk_application" "elastic_app" {
  name = var.elastic_app
}
 
# Create elastic beanstalk Environment

data "external" "git_hash" {
  program = ["${path.module}/../scripts/git-hash.sh"]
}

data "archive_file" "package" {
  type        = "zip"
  output_path = "${path.module}/../dist/${var.elastic_app}.zip"
  source_dir  = "${path.module}/.."
  excludes    = ["LICENSE", "__pycache__", "docs", "scripts", "README.md", "dist", "infra", ".github", ".gitignore"]
}

resource "aws_s3_bucket" "deployment_bucket" {
  bucket = "network-visualizer-source"
}

resource "aws_s3_object" "package" {
  bucket = aws_s3_bucket.deployment_bucket.id
  key    = "beanstalk/${var.elastic_app}.zip"
  source = data.archive_file.package.output_path
}

resource "aws_elastic_beanstalk_application_version" "app_version" {
  name        = data.external.git_hash.result["version"]
  application = aws_elastic_beanstalk_application.elastic_app.name
  description = "application version created by terraform"
  bucket      = aws_s3_bucket.deployment_bucket.id
  key         = aws_s3_object.package.id
}

data "aws_elastic_beanstalk_solution_stack" "app_stack" {
  most_recent = true
  name_regex = var.solution_stack_name_match
}
 
resource "aws_elastic_beanstalk_environment" "app_env" {
  name                = var.app_env
  application         = aws_elastic_beanstalk_application.elastic_app.name
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.app_stack.name
  tier                = var.tier
  version_label       = aws_elastic_beanstalk_application_version.app_version.name
 
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "True"
  }
 
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", data.aws_subnets.public.ids)
    # value     = data.aws_subnets.public.ids
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "internet facing"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = 1
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = 2
  }
  
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }
 
}