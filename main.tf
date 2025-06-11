resource "awscc_connect_view" "SecuredEmailView" {
  # Required parameters
  actions      = ["Create", "Read", "Update", "Delete"] # Adjust based on your needs
  instance_arn = "arn:aws:connect:us-east-1:687244881512:instance/3ad0cc25-b775-4078-8d60-c6460ee05d6b"
  name         = "SecuredEmailView"
  
  # Your schema as JSON template
  template = jsonencode({
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
  })

  # Optional parameters
  description = "Custom view with attribute bars and text area"
  
  tags = [
    {
      key   = "Environment"
      value = "Production"
    },
    {
      key   = "Team"
      value = "CustomerService"
    }
  ]
}

# Output the created view details
output "view_id" {
  value = awscc_connect_view.SecuredEmailView.view_id
}

output "view_arn" {
  value = awscc_connect_view.SecuredEmailView.view_arn
}



resource "aws_connect_contact_flow" "EmailInbound2" {
  instance_id  = "3ad0cc25-b775-4078-8d60-c6460ee05d6b"
  name         = "EmailInbound2"
  description  = "Secured Messaging Contact Flow"
  type         = "CONTACT_FLOW"
  filename     = "EmailInbound2.json"
  content_hash = filebase64sha256("EmailInbound.json")
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