import sendgrid
from sendgrid.helpers.mail import Mail, Email, To, Content

SENDGRID_API_KEY = "your_sendgrid_api_key"

def send_email(to_email: str, subject: str, content: str):
    sg = sendgrid.SendGridAPIClient(api_key=SENDGRID_API_KEY)
    from_email = Email("noreply@example.com")
    to_email = To(to_email)
    content = Content("text/plain", content)
    
    mail = Mail(from_email, to_email, subject, content)
    response = sg.send(mail)
    return response.status_code
