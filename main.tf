terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 0.56.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "us-east-1"
}

provider "awscc" {
  region = "us-east-1"
}

resource "aws_cloudformation_stack" "connect_view_stack" {
  name          = "ConnectViewStack"
  template_body = file("connect_view_template.yaml")
}


resource "aws_connect_contact_flow" "EmailInbound2" {
  instance_id  = "3ad0cc25-b775-4078-8d60-c6460ee05d6b"
  name         = "EmailInbound2"
  description  = "Secured Messaging Contact Flow"
  type         = "CONTACT_FLOW"
  filename     = "EmailInbound2.json"
  content_hash = filebase64sha256("EmailInbound2.json")
  tags = {
    "Name"        = "Secured Messaging Contact Flow",
    "Application" = "Terraform",
    "Method"      = "Create"
  }
}




data "aws_iam_policy_document" "assume_role_securedMessaging" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}




resource "aws_iam_role" "iam_for_securedLambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role_securedMessaging.json
}

data "archive_file" "Securedlambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "Secured_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function_payload.zip"
  function_name = "Secured_lambda"
  role          = aws_iam_role.iam_for_securedLambda.arn
  handler       = "index.test"

  source_code_hash = data.archive_file.Securedlambda.output_base64sha256

  runtime = "nodejs18.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}
