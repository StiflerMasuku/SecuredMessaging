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
                        "Attributes": [
                            {
                                "Label": "ContactId",
                                "Value": "$.Attributes.ContactId"
                            }
                        ]
                    },
                    "Content": []
                },
                {
                    "_id": "AttributeBar_1744108839275",
                    "Type": "AttributeBar",
                    "Props": {
                        "Attributes": [
                            {
                                "Label": "To_Address",
                                "Value": "$.Attributes.To_Address"
                            }
                        ]
                    },
                    "Content": []
                },
                {
                    "_id": "AttributeBar_1744108868955",
                    "Type": "AttributeBar",
                    "Props": {
                        "Attributes": [
                            {
                                "Label": "From_Address",
                                "Value": "$.Attributes.From_Address"
                            }
                        ]
                    },
                    "Content": []
                },
                {
                    "_id": "TextArea_1742387422746",
                    "Type": "TextArea",
                    "Props": {
                        "DefaultValue": "Enter additional notes here..."
                    },
                    "Content": []
                }
            ]
        }
    ]
}
EOF
  name         = "SecuredEmailView"
  description  = "Task view with attribute bars and notes section"
}

resource "aws_connect_contact_flow" "EmailInbound2" {

  instance_id = "3ad0cc25-b775-4078-8d60-c6460ee05d6b"
  name        = "EmailInbound2"
  description = "EmailInbound2"
  type        = "CONTACT_FLOW"
  content = <<EOF
 {
  "Version": "2019-10-30",
  "StartAction": "efc04276-5c10-4da4-82be-a659358a844a",
  "Metadata": {
    "entryPointPosition": {
      "x": 50,
      "y": 50
    },
    "ActionMetadata": {
      "4504adbf-b1eb-4a54-a707-ec7985926ecc": {
        "position": {
          "x": 762,
          "y": 118
        }
      },
      "efc04276-5c10-4da4-82be-a659358a844a": {
        "position": {
          "x": 206,
          "y": 73
        }
      },
      "fd6ff744-6496-4b44-8e90-1aae4e7ef69f": {
        "position": {
          "x": 475,
          "y": 78
        }
      }
    },
    "Annotations": [],
    "name": "Simple Flow",
    "description": "",
    "type": "contactFlow",
    "status": "PUBLISHED",
    "hash": {}
  },
  "Actions": [
    {
      "Parameters": {},
      "Identifier": "4504adbf-b1eb-4a54-a707-ec7985926ecc",
      "Type": "DisconnectParticipant",
      "Transitions": {}
    },
    {
      "Parameters": {
        "FlowLoggingBehavior": "Enabled"
      },
      "Identifier": "efc04276-5c10-4da4-82be-a659358a844a",
      "Type": "UpdateFlowLoggingBehavior",
      "Transitions": {
        "NextAction": "fd6ff744-6496-4b44-8e90-1aae4e7ef69f"
      }
    },
    {
      "Parameters": {
        "Text": "Hi"
      },
      "Identifier": "fd6ff744-6496-4b44-8e90-1aae4e7ef69f",
      "Type": "MessageParticipant",
      "Transitions": {
        "NextAction": "4504adbf-b1eb-4a54-a707-ec7985926ecc",
        "Errors": [
          {
            "NextAction": "4504adbf-b1eb-4a54-a707-ec7985926ecc",
            "ErrorType": "NoMatchingError"
          }
        ]
      }
    }
  ]
}
EOF
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
