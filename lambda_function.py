import json
 
def lambda_handler(event, context):
    print(event)
   
   
    contact_id = event['Details']['ContactData']['ContactId']
    print(f"Contact ID: {contact_id}")
   
    email_address = event['Details']['ContactData']['CustomerEndpoint']['Address'] #sfisostee@icloud.com#
    connect_email_address = event['Details']['ContactData']['SystemEndpoint']['Address'] #sfisostee@icloud.com#
    email_subject = event['Details']['ContactData']['Name'] #sfisostee@icloud.com#
    
    print(f"Email Address: {email_address}")
   
    print(f"Email Address: {connect_email_address}")
    print(f"Email Address: {email_subject}")
   
    user_id = f"user_{hash(email_address)}"
    print(f"User ID: {user_id}")
   
   
    response = {
        'ContactId': contact_id,
        'UserId': user_id,
        'Email': email_address,
        'EmailSubject': email_subject,
        'ConnectEmail': connect_email_address
    }
    print(response)
   
    return response
 
 
