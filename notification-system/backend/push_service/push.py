import firebase_admin
from firebase_admin import credentials, messaging

cred = credentials.Certificate("path_to_your_firebase_credentials.json")
firebase_admin.initialize_app(cred)

def send_push_notification(token: str, title: str, body: str):
    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body,
        ),
        token=token,
    )
    
    response = messaging.send(message)
    return response
