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
  "StartAction": "f8c55a6e-7ec2-4347-b35c-e2578a2c5445",
  "Metadata": {
    "entryPointPosition": {
      "x": -588,
      "y": 394
    },
    "ActionMetadata": {
      "2b9c92f1-25dc-4d0d-8bfe-a90f9754b0d9": {
        "position": {
          "x": 3079,
          "y": 67
        },
        "parameters": {
          "EventHooks": {
            "DefaultAgentUI": {
              "displayName": "EmailShowView"
            }
          }
        }
      },
      "424ba4c7-4ae6-41e4-9c12-56cbc6ea9987": {
        "position": {
          "x": 2639,
          "y": 28
        },
        "parameters": {
          "Attributes": {
            "ContactId": {
              "useDynamic": true
            },
            "QueueName": {
              "useDynamic": true
            },
            "CustomerEndpoint": {
              "useDynamic": true
            }
          }
        },
        "dynamicParams": [
          "ContactId",
          "QueueName",
          "CustomerEndpoint"
        ]
      },
      "1417d161-fbc1-4095-b822-32139bd194e3": {
        "position": {
          "x": 2713,
          "y": 1216
        },
        "parameters": {
          "Attributes": {
            "ContactId": {
              "useDynamic": true
            },
            "QueueName": {
              "useDynamic": true
            },
            "CustomerEndpoint": {
              "useDynamic": true
            }
          }
        },
        "dynamicParams": [
          "ContactId",
          "QueueName",
          "CustomerEndpoint"
        ]
      },
      "615cb752-a435-4e79-bb6d-980ad2af6424": {
        "position": {
          "x": 3064,
          "y": 1251
        },
        "parameters": {
          "EventHooks": {
            "DefaultAgentUI": {
              "displayName": "EmailShowView"
            }
          }
        }
      },
      "8ed4d11e-5010-4c2d-b8f1-8fbac003ef08": {
        "position": {
          "x": 2784,
          "y": 537
        },
        "parameters": {
          "Attributes": {
            "ContactId": {
              "useDynamic": true
            },
            "QueueName": {
              "useDynamic": true
            },
            "CustomerEndpoint": {
              "useDynamic": true
            }
          }
        },
        "dynamicParams": [
          "ContactId",
          "QueueName",
          "CustomerEndpoint"
        ]
      },
      "032a46d6-5747-4b06-92be-df569da2dfe6": {
        "position": {
          "x": 3100,
          "y": 328
        },
        "parameters": {
          "EventHooks": {
            "DefaultAgentUI": {
              "displayName": "EmailShowView"
            }
          }
        }
      },
      "f8c55a6e-7ec2-4347-b35c-e2578a2c5445": {
        "position": {
          "x": -247,
          "y": 622
        }
      },
      "49521d9b-0f80-4555-87e9-d7bf0a202dc5": {
        "position": {
          "x": 3975,
          "y": 517
        }
      },
      "6c1d56f0-8cc3-41c4-b6fa-0d3c8ad88ffd": {
        "position": {
          "x": 134,
          "y": 508
        },
        "parameters": {
          "LambdaFunctionARN": {
            "displayName": "email_lambda"
          }
        },
        "dynamicMetadata": {}
      },
      "2575bb66-4f89-4745-82f4-64f7bdb55068": {
        "position": {
          "x": 4615,
          "y": 473
        }
      },
      "d01eb6c8-4fc7-44cd-8e7c-b3380e94f34a": {
        "position": {
          "x": 2258,
          "y": 36
        },
        "parameters": {
          "QueueId": {
            "displayName": "eBook Queue"
          }
        },
        "queue": {
          "text": "eBook Queue"
        }
      },
      "5c951ee5-9e36-4437-8b07-61f361766099": {
        "position": {
          "x": 2332,
          "y": 1129
        },
        "parameters": {
          "QueueId": {
            "displayName": "eBook Queue"
          }
        },
        "queue": {
          "text": "eBook Queue"
        }
      },
      "fab563d9-5808-4956-9121-f19cdc625287": {
        "position": {
          "x": 2428,
          "y": 477
        },
        "parameters": {
          "QueueId": {
            "displayName": "eBook Queue"
          }
        },
        "queue": {
          "text": "eBook Queue"
        }
      },
      "2e94555c-867f-4674-b2a2-18c3c7c7fb75": {
        "position": {
          "x": 523,
          "y": 533
        },
        "parameters": {
          "Attributes": {
            "UserId": {
              "useDynamic": true
            },
            "Email": {
              "useDynamic": true
            },
            "EmailSubject": {
              "useDynamic": true
            },
            "ConnectEmail": {
              "useDynamic": true
            }
          }
        },
        "dynamicParams": [
          "UserId",
          "Email",
          "EmailSubject",
          "ConnectEmail"
        ]
      },
      "1df18bdc-3e1b-4263-9a76-8fbedf4ffa54": {
        "position": {
          "x": 1497,
          "y": 390
        },
        "conditions": [],
        "conditionMetadata": [
          {
            "id": "65a0cebd-fa93-46fd-96df-f39140b75255",
            "operator": {
              "name": "Contains",
              "value": "Contains",
              "shortDisplay": "contains"
            },
            "value": "Proof of Payment"
          },
          {
            "id": "d8be341a-0f1b-49fa-bea4-2cee97e3b215",
            "operator": {
              "name": "Contains",
              "value": "Contains",
              "shortDisplay": "contains"
            },
            "value": "Credit Card"
          },
          {
            "id": "5d97ecb0-26f2-4e1c-b0c9-41fda0ea5ebc",
            "operator": {
              "name": "Contains",
              "value": "Contains",
              "shortDisplay": "contains"
            },
            "value": "Transactions"
          },
          {
            "id": "93fba679-26c5-4723-a7cd-0f6e99e7684f",
            "operator": {
              "name": "Contains",
              "value": "Contains",
              "shortDisplay": "contains"
            },
            "value": "Bank of Ireland Life"
          },
          {
            "id": "75a67a61-d0e7-4343-845a-1b9b2b7170f9",
            "operator": {
              "name": "Contains",
              "value": "Contains",
              "shortDisplay": "contains"
            },
            "value": "Savings or Deposit"
          }
        ]
      }
    },
    "Annotations": [],
    "name": "Email Inbound",
    "description": "",
    "type": "contactFlow",
    "status": "published",
    "hash": {}
  },
  "Actions": [
    {
      "Parameters": {
        "EventHooks": {
          "DefaultAgentUI": "arn:aws:connect:us-east-1:687244881512:instance/3ad0cc25-b775-4078-8d60-c6460ee05d6b/contact-flow/6ab7630c-8aa7-466d-9fce-33ba30636498"
        }
      },
      "Identifier": "2b9c92f1-25dc-4d0d-8bfe-a90f9754b0d9",
      "Type": "UpdateContactEventHooks",
      "Transitions": {
        "NextAction": "49521d9b-0f80-4555-87e9-d7bf0a202dc5",
        "Errors": [
          {
            "NextAction": "49521d9b-0f80-4555-87e9-d7bf0a202dc5",
            "ErrorType": "NoMatchingError"
          }
        ]
      }
    },
    {
      "Parameters": {
        "Attributes": {
          "ContactId": "$.ContactId",
          "QueueName": "$.Queue.Name",
          "CustomerEndpoint": "$.CustomerEndpoint.Address"
        },
        "TargetContact": "Current"
      },
      "Identifier": "424ba4c7-4ae6-41e4-9c12-56cbc6ea9987",
      "Type": "UpdateContactAttributes",
      "Transitions": {
        "NextAction": "2b9c92f1-25dc-4d0d-8bfe-a90f9754b0d9",
        "Errors": [
          {
            "NextAction": "2b9c92f1-25dc-4d0d-8bfe-a90f9754b0d9",
            "ErrorType": "NoMatchingError"
          }
        ]
      }
    },
    {
      "Parameters": {
        "Attributes": {
          "ContactId": "$.ContactId",
          "QueueName": "$.Queue.Name",
          "CustomerEndpoint": "$.CustomerEndpoint.Address"
        },
        "TargetContact": "Current"
      },
      "Identifier": "1417d161-fbc1-4095-b822-32139bd194e3",
      "Type": "UpdateContactAttributes",
      "Transitions": {
        "NextAction": "615cb752-a435-4e79-bb6d-980ad2af6424",
        "Errors": [
          {
            "NextAction": "615cb752-a435-4e79-bb6d-980ad2af6424",
            "ErrorType": "NoMatchingError"
          }
        ]
      }
    },
    {
      "Parameters": {
        "EventHooks": {
          "DefaultAgentUI": "arn:aws:connect:us-east-1:687244881512:instance/3ad0cc25-b775-4078-8d60-c6460ee05d6b/contact-flow/6ab7630c-8aa7-466d-9fce-33ba30636498"
        }
      },
      "Identifier": "615cb752-a435-4e79-bb6d-980ad2af6424",
      "Type": "UpdateContactEventHooks",
      "Transitions": {
        "NextAction": "49521d9b-0f80-4555-87e9-d7bf0a202dc5",
        "Errors": [
          {
            "NextAction": "49521d9b-0f80-4555-87e9-d7bf0a202dc5",
            "ErrorType": "NoMatchingError"
          }
        ]
      }
    },
    {
      "Parameters": {
        "Attributes": {
          "ContactId": "$.ContactId",
          "QueueName": "$.Queue.Name",
          "CustomerEndpoint": "$.CustomerEndpoint.Address"
        },
        "TargetContact": "Current"
      },
      "Identifier": "8ed4d11e-5010-4c2d-b8f1-8fbac003ef08",
      "Type": "UpdateContactAttributes",
      "Transitions": {
        "NextAction": "032a46d6-5747-4b06-92be-df569da2dfe6",
        "Errors": [
          {
            "NextAction": "032a46d6-5747-4b06-92be-df569da2dfe6",
            "ErrorType": "NoMatchingError"
          }
        ]
      }
    },
    {
      "Parameters": {
        "EventHooks": {
          "DefaultAgentUI": "arn:aws:connect:us-east-1:687244881512:instance/3ad0cc25-b775-4078-8d60-c6460ee05d6b/contact-flow/6ab7630c-8aa7-466d-9fce-33ba30636498"
        }
      },
      "Identifier": "032a46d6-5747-4b06-92be-df569da2dfe6",
      "Type": "UpdateContactEventHooks",
      "Transitions": {
        "NextAction": "49521d9b-0f80-4555-87e9-d7bf0a202dc5",
        "Errors": [
          {
            "NextAction": "49521d9b-0f80-4555-87e9-d7bf0a202dc5",
            "ErrorType": "NoMatchingError"
          }
        ]
      }
    },
    {
      "Parameters": {
        "FlowLoggingBehavior": "Enabled"
      },
      "Identifier": "f8c55a6e-7ec2-4347-b35c-e2578a2c5445",
      "Type": "UpdateFlowLoggingBehavior",
      "Transitions": {
        "NextAction": "6c1d56f0-8cc3-41c4-b6fa-0d3c8ad88ffd"
      }
    },
    {
      "Parameters": {},
      "Identifier": "49521d9b-0f80-4555-87e9-d7bf0a202dc5",
      "Type": "TransferContactToQueue",
      "Transitions": {
        "NextAction": "2575bb66-4f89-4745-82f4-64f7bdb55068",
        "Errors": [
          {
            "NextAction": "2575bb66-4f89-4745-82f4-64f7bdb55068",
            "ErrorType": "QueueAtCapacity"
          },
          {
            "NextAction": "2575bb66-4f89-4745-82f4-64f7bdb55068",
            "ErrorType": "NoMatchingError"
          }
        ]
      }
    },
    {
      "Parameters": {
        "LambdaFunctionARN": "arn:aws:lambda:us-east-1:687244881512:function:email_lambda",
        "InvocationTimeLimitSeconds": "3",
        "ResponseValidation": {
          "ResponseType": "JSON"
        }
      },
      "Identifier": "6c1d56f0-8cc3-41c4-b6fa-0d3c8ad88ffd",
      "Type": "InvokeLambdaFunction",
      "Transitions": {
        "NextAction": "2e94555c-867f-4674-b2a2-18c3c7c7fb75",
        "Errors": [
          {
            "NextAction": "2e94555c-867f-4674-b2a2-18c3c7c7fb75",
            "ErrorType": "NoMatchingError"
          }
        ]
      }
    },
    {
      "Parameters": {},
      "Identifier": "2575bb66-4f89-4745-82f4-64f7bdb55068",
      "Type": "DisconnectParticipant",
      "Transitions": {}
    },
    {
      "Parameters": {
        "QueueId": "arn:aws:connect:us-east-1:687244881512:instance/3ad0cc25-b775-4078-8d60-c6460ee05d6b/queue/582a6fea-edb9-4c59-9ca3-ea035edb4324"
      },
      "Identifier": "d01eb6c8-4fc7-44cd-8e7c-b3380e94f34a",
      "Type": "UpdateContactTargetQueue",
      "Transitions": {
        "NextAction": "424ba4c7-4ae6-41e4-9c12-56cbc6ea9987",
        "Errors": [
          {
            "NextAction": "424ba4c7-4ae6-41e4-9c12-56cbc6ea9987",
            "ErrorType": "NoMatchingError"
          }
        ]
      }
    },
    {
      "Parameters": {
        "QueueId": "arn:aws:connect:us-east-1:687244881512:instance/3ad0cc25-b775-4078-8d60-c6460ee05d6b/queue/582a6fea-edb9-4c59-9ca3-ea035edb4324"
      },
      "Identifier": "5c951ee5-9e36-4437-8b07-61f361766099",
      "Type": "UpdateContactTargetQueue",
      "Transitions": {
        "NextAction": "1417d161-fbc1-4095-b822-32139bd194e3",
        "Errors": [
          {
            "NextAction": "1417d161-fbc1-4095-b822-32139bd194e3",
            "ErrorType": "NoMatchingError"
          }
        ]
      }
    },
    {
      "Parameters": {
        "QueueId": "arn:aws:connect:us-east-1:687244881512:instance/3ad0cc25-b775-4078-8d60-c6460ee05d6b/queue/582a6fea-edb9-4c59-9ca3-ea035edb4324"
      },
      "Identifier": "fab563d9-5808-4956-9121-f19cdc625287",
      "Type": "UpdateContactTargetQueue",
      "Transitions": {
        "NextAction": "8ed4d11e-5010-4c2d-b8f1-8fbac003ef08",
        "Errors": [
          {
            "NextAction": "8ed4d11e-5010-4c2d-b8f1-8fbac003ef08",
            "ErrorType": "NoMatchingError"
          }
        ]
      }
    },
    {
      "Parameters": {
        "Attributes": {
          "UserId": "$.External.UserId",
          "Email": "$.External.Email",
          "EmailSubject": "$.SegmentAttributes['connect:EmailSubject']",
          "ConnectEmail": "$.External.ConnectEmail"
        },
        "TargetContact": "Current"
      },
      "Identifier": "2e94555c-867f-4674-b2a2-18c3c7c7fb75",
      "Type": "UpdateContactAttributes",
      "Transitions": {
        "NextAction": "1df18bdc-3e1b-4263-9a76-8fbedf4ffa54",
        "Errors": [
          {
            "NextAction": "1df18bdc-3e1b-4263-9a76-8fbedf4ffa54",
            "ErrorType": "NoMatchingError"
          }
        ]
      }
    },
    {
      "Parameters": {
        "ComparisonValue": "$.SegmentAttributes['connect:EmailSubject']"
      },
      "Identifier": "1df18bdc-3e1b-4263-9a76-8fbedf4ffa54",
      "Type": "Compare",
      "Transitions": {
        "NextAction": "fab563d9-5808-4956-9121-f19cdc625287",
        "Conditions": [
          {
            "NextAction": "d01eb6c8-4fc7-44cd-8e7c-b3380e94f34a",
            "Condition": {
              "Operator": "TextContains",
              "Operands": [
                "Proof of Payment"
              ]
            }
          },
          {
            "NextAction": "fab563d9-5808-4956-9121-f19cdc625287",
            "Condition": {
              "Operator": "TextContains",
              "Operands": [
                "Credit Card"
              ]
            }
          },
          {
            "NextAction": "fab563d9-5808-4956-9121-f19cdc625287",
            "Condition": {
              "Operator": "TextContains",
              "Operands": [
                "Transactions"
              ]
            }
          },
          {
            "NextAction": "5c951ee5-9e36-4437-8b07-61f361766099",
            "Condition": {
              "Operator": "TextContains",
              "Operands": [
                "Bank of Ireland Life"
              ]
            }
          },
          {
            "NextAction": "fab563d9-5808-4956-9121-f19cdc625287",
            "Condition": {
              "Operator": "TextContains",
              "Operands": [
                "Savings or Deposit"
              ]
            }
          }
        ],
        "Errors": [
          {
            "NextAction": "fab563d9-5808-4956-9121-f19cdc625287",
            "ErrorType": "NoMatchingCondition"
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
