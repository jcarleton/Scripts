#!/usr/bin/env python

# python mailer by Jesse Carleton
# iterates through list, addresses in targets.txt
# target format should be with quotes, "user.name@domain.com"
# sends mail with MIME Multipart, for text and HTML messages
# image support available with loaded module, but not used in this version

import sys
import base64
from smtplib import SMTP
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from email.mime.application import MIMEApplication

# load email addresses
targets = open('targets.txt', "rb")


def mailme():
    for line in targets:
        line = line.replace('\\r\\n', '')
        encodedTarget = base64.urlsafe_b64encode('%s' % line)
        msg = MIMEMultipart('alternative')
        m_source = '<sender@domain.com>'
        m_target = '%s' % line
        smtp_server = 'mail.domain.com'
        smtp_port = '25'
        msg['From'] = m_source
        msg['Subject'] = "Order Status"
        msg['To'] = m_target
        smtp = SMTP()
        smtp.set_debuglevel(0)
        smtp.connect(smtp_server, smtp_port)

        message_text = ('TEXT MESSAGE for %s') % (encodedTarget)

        message_html = ("""<body>
                        <h1>HTML MESSAGE for %s</h1>
                        </body>"""
                        ) % (encodedTarget)

        txt = MIMEText(message_text, 'plain')
        web = MIMEText(message_html, 'html')

        msg.attach(txt)
        msg.attach(web)
        smtp.sendmail(m_source, m_target, msg.as_string())
        smtp.quit()


if __name__ == "__main__":
    mailme()
    sys.exit(0)