# Complete Terraform script for AWS Connect View using CloudFormation
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

provider "awscc" {
  region = "us-east-1"
}

# Create the Connect View using CloudFormation
resource "awscc_connect_view" "SecuredEmailView" {
  instance_arn = "arn:aws:connect:us-east-1:687244881512:instance/3ad0cc25-b775-4078-8d60-c6460ee05d6b"
  actions      = ["ActionSelected", "SubmitResults"]
  template     = <<EOF
{
    "Head": {
        "Configuration": {
            "Layout": {
                "Columns": [
                    12
                ]
            }
        },
        "Title": "Dynamic Task View"
    },
    "Body": [
        {
            "_id": "Header_1",
            "Type": "Header",
            "Props": {
                "variant": "h1",
                "description": ""
            },
            "Content": [
                "Task Information"
            ]
        },
        {
            "_id": "Section_1",
            "Type": "Section",
            "Props": {
                "Heading": "Client Information"
            },
            "Content": [
                {
                    "_id": "AttributeBar_1742218105567",
                    "Type": "AttributeBar",
                    "Props": {
                        "Attributes": []
                    },
                    "Content": []
                },
                {
                    "_id": "AttributeBar_1744108839275",
                    "Type": "AttributeBar",
                    "Props": {
                        "Attributes": []
                    },
                    "Content": []
                },
                {
                    "_id": "AttributeBar_1744108868955",
                    "Type": "AttributeBar",
                    "Props": {
                        "Attributes": []
                    },
                    "Content": []
                }
            ],
            "Configuration": {
                "Layout": {
                    "Columns": "12"
                }
            }
        },
        {
            "_id": "Section_2",
            "Type": "Section",
            "Props": {
                "Heading": "Notes"
            },
            "Content": [
                {
                    "_id": "Form_1",
                    "Type": "Form",
                    "Props": {
                        "HideBorder": true
                    },
                    "Content": [
                        {
                            "_id": "TextArea_1742387422746",
                            "Type": "TextArea",
                            "Props": {
                                "Label": "Notes",
                                "Name": "Notes",
                                "DefaultValue": "",
                                "Placeholder": "Enter your notes here...",
                                "Required": false,
                                "Rows": 4
                            },
                            "Content": []
                        }
                    ],
                    "Configuration": {
                        "Layout": {
                            "Columns": [
                                "12"
                            ]
                        }
                    }
                }
            ],
            "Configuration": {
                "Layout": {
                    "Columns": "12"
                }
            }
        },
        {
            "_id": "ButtonGroup_1",
            "Type": "ButtonGroup",
            "Props": {
                "Items": [
                    {
                        "Variant": "normal",
                        "IconAlign": "left",
                        "Disabled": false,
                        "Action": "ActionSelected",
                        "Label": "Cancel",
                        "FormAction": "",
                        "IconName": "close"
                    },
                    {
                        "Variant": "primary",
                        "Disabled": false,
                        "Action": "SubmitResults",
                        "Label": "Submit",
                        "FormAction": "submit",
                        "IconName": "upload"
                    }
                ],
                "ButtonsOrientation": "horizontal",
                "SpaceBetweenButtons": "s"
            },
            "Content": []
        }
    ]
}
EOF
  name         = "SecuredEmailView"
  description  = "Task view with attribute bars and notes section"
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
