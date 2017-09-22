#!/usr/bin/env python

import smtplib

from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

def sendreport(eFrom,eTo,eHost,MsgFile):
	#print eFrom,eTo,eHost,MsgFile
# Create message container - the correct MIME type is multipart/alternative.
	msg = MIMEMultipart('alternative')
	msg['Subject'] = "Tickerlick Trade Alert"
	msg['From'] = eFrom 
	msg['To'] = eTo 
# Create the body of the message (HTML version).
#create html using report data
	hbody = ""
	f = open(MsgFile,"r")
	for line in f.readlines():
		fields = line.split(",")
		hbody = hbody + "<tr><td>" + fields[0] + "</td><td>" + fields[1] + "</td><td>" + fields[2] + "</td><td>" + fields[3] + "</td></tr>"
	f.close()
#	print hbody
	html = """<html>
	<head></head>
	<body><p><br>
	"""
	html = html + hbody 
  	html = html +  """<tr><td><a href="http://www.tickerlick.com">Visit TICKERLICK.COM!</a></td></tr>
   </table>
   </br></p>
  </body>
</html>"""
#	print html
# Record the MIME types text/html.
	part2 = MIMEText(html, 'html')

# Attach parts into message container.
	msg.attach(part2)

# Send the message via local SMTP server.
	s = smtplib.SMTP(eHost)
# sendmail function takes 3 arguments: sender's address, recipient's address
# and message to send - here it is sent as one string.
	s.sendmail(eFrom,eTo, msg.as_string())
	s.quit()
