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

# Create the Connect View using CloudFormation
resource "aws_cloudformation_stack" "SecuredEmailView" {
  name = "SecuredEmailView"
  
  template_body = jsonencode({
    AWSTemplateFormatVersion = "2010-09-09"
    Description = "AWS Connect View for Secured Email with attribute bars and text area"
    
    Resources = {
      SecuredEmailView = {
        Type = "AWS::Connect::View"
        Properties = {
          InstanceArn = "arn:aws:connect:us-east-1:687244881512:instance/3ad0cc25-b775-4078-8d60-c6460ee05d6b"
          Name        = "SecuredEmailView"
          Description = "Custom view with attribute bars and text area"
          Actions     = ["Create", "Read", "Update", "Delete"]
          
          Template = {
            type = "object"
            properties = {
              AttributeBar_1742218105567 = {
                properties = {
                  Attributes = {
                    items = {
                      properties = {
                        Value = {
                          anyOf = [
                            {
                              type    = "string"
                              pattern = "^$|^(?!\\$\\.).+"
                            },
                            {
                              type = "number"
                            }
                          ]
                        }
                      }
                      type     = "object"
                      required = ["Value"]
                    }
                    type = "array"
                  }
                }
                type     = "object"
                required = ["Attributes"]
              }
              
              AttributeBar_1744108839275 = {
                properties = {
                  Attributes = {
                    items = {
                      properties = {
                        Value = {
                          anyOf = [
                            {
                              type    = "string"
                              pattern = "^$|^(?!\\$\\.).+"
                            },
                            {
                              type = "number"
                            }
                          ]
                        }
                      }
                      type     = "object"
                      required = ["Value"]
                    }
                    type = "array"
                  }
                }
                type     = "object"
                required = ["Attributes"]
              }
              
              AttributeBar_1744108868955 = {
                properties = {
                  Attributes = {
                    items = {
                      properties = {
                        Value = {
                          anyOf = [
                            {
                              type    = "string"
                              pattern = "^$|^(?!\\$\\.).+"
                            },
                            {
                              type = "number"
                            }
                          ]
                        }
                      }
                      type     = "object"
                      required = ["Value"]
                    }
                    type = "array"
                  }
                }
                type     = "object"
                required = ["Attributes"]
              }
              
              TextArea_1742387422746 = {
                properties = {
                  DefaultValue = {
                    anyOf = [
                      {
                        type    = "string"
                        pattern = "^$|^(?!\\$\\.).+"
                      },
                      {
                        type = "number"
                      }
                    ]
                  }
                }
                type = "object"
              }
            }
            required = [
              "AttributeBar_1742218105567",
              "AttributeBar_1744108839275", 
              "AttributeBar_1744108868955"
            ]
            "$defs" = {
              ViewCondition = {
                "$id" = "/view/condition"
                type = "object"
                patternProperties = {
                  "^(MoreThan|LessThan|NotEqual|Equal|Include)$" = {
                    type = "object"
                    properties = {
                      ElementByKey = {
                        type = "string"
                      }
                      ElementByValue = {
                        anyOf = [
                          {
                            type = "number"
                          },
                          {
                            type = "string"
                          }
                        ]
                      }
                    }
                    additionalProperties = false
                  }
                  "^(AndConditions|OrConditions)$" = {
                    type = "array"
                    items = {
                      "$ref" = "/view/condition"
                    }
                  }
                }
                additionalProperties = false
              }
            }
          }
          
          Tags = [
            {
              Key   = "Environment"
              Value = "Production"
            },
            {
              Key   = "Team"
              Value = "CustomerService"
            }
          ]
        }
      }
    }
    
    Outputs = {
      ViewId = {
        Description = "The ID of the created Connect View"
        Value = { Ref = "SecuredEmailView" }
        Export = {
          Name = "SecuredEmailView-ViewId"
        }
      }
      ViewArn = {
        Description = "The ARN of the created Connect View"
        Value = { "Fn::GetAtt" = ["SecuredEmailView", "ViewArn"] }
        Export = {
          Name = "SecuredEmailView-ViewArn"
        }
      }
    }
  })
  
  tags = {
    Environment = "Production"
    Team        = "CustomerService"
    ManagedBy   = "Terraform"
  }
  
  # Enable rollback on failure
  on_failure = "ROLLBACK"
  
  # Timeout for stack creation/update
  timeout_in_minutes = 10
}

# Output the created view details
output "view_id" {
  description = "The ID of the created Connect View"
  value       = aws_cloudformation_stack.SecuredEmailView.outputs["ViewId"]
}

output "view_arn" {
  description = "The ARN of the created Connect View"
  value       = aws_cloudformation_stack.SecuredEmailView.outputs["ViewArn"]
}

output "cloudformation_stack_id" {
  description = "The CloudFormation stack ID"
  value       = aws_cloudformation_stack.SecuredEmailView.id
}

output "cloudformation_stack_outputs" {
  description = "All CloudFormation stack outputs"
  value       = aws_cloudformation_stack.SecuredEmailView.outputs
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
