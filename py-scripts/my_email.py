import smtplib, ssl
from email.message import EmailMessage

port = 465  # For SSL
smtp_server = "smtp.gmail.com"
sender_email = "test@gmail.com" #Enter your mail Addess
receiver_email = input("Enter receiver address :") #Enter reciver mail address
password="test" #Enter 16 digit app password

msg = EmailMessage()
msg.set_content("Python Test Mail")
msg['Subject'] = "This is from Python Gmail!"
msg['From'] = sender_email
msg['To'] = receiver_email

context = ssl.create_default_context()
with smtplib.SMTP_SSL(smtp_server, port, context=context) as server:
    server.login(sender_email, password)
    server.send_message(msg, from_addr=sender_email, to_addrs=receiver_email)
    print("Email Sent Successfully")
