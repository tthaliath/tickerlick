#!/usr/bin/env python

import smtplib

from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

def getcolor(tradesignal):
	if (tradesignal == 'Buy'):
		return '#7FFF00'
	else:
		return '#DC143C'


def sendreport(eFrom,eTo,eHost,MsgFile):
	#print eFrom,eTo,eHost,MsgFile
# Create message container - the correct MIME type is multipart/alternative.
	msg = MIMEMultipart('alternative')
	msg['Subject'] = "Tickerlick MACD Trade Alert"
	msg['From'] = eFrom 
	msg['To'] = eTo 
# Create the body of the message (HTML version).
#create html using report data
	hbody = ""
	f = open(MsgFile,"r")
	for line in f.readlines():
		fields = line.split(",")
		hbody = hbody + "<tr><td>" + fields[0] + "</td><td>" + fields[1] + "</td><td bgcolor='"+getcolor(fields[2])+"'>" + fields[2] + "</td><td>" + fields[3] + "</td></tr>"
	f.close()
	html = """<html>
	<head></head>
	<body><p><br><table border="1">
	"""
	html = html + hbody 
  	html = html +  """<tr><td><a href="http://www.tickerlick.com">Visit TICKERLICK.COM!</a></td></tr>
   </table>
   </br></p>
  </body>
</html>"""
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
