#!/usr/bin/env python

import MySQLdb as mdb
import sys
import os
import json
from tradealert import sendreport 
## yyyy-mm-dd format
import datetime
mylist = []
today = str(datetime.date.today())
mylist.append(today)
today = mylist[0] # print the date object, not the container ;-)
json_data = json.load(open('/home/tthaliath/tickerlick/tradevantage/config.json'))
dbhost = json_data['mysql']['host']
dbuser = json_data['mysql']['user']
dbpassword = json_data['mysql']['passwd']
tickmasterdb = json_data['mysql']['db']
#email details
email_host =  json_data['email']['smtplibhost']
email_to = json_data['email']['To']
email_from = json_data['email']['From']
def getprevday(cur,today):
	cur.execute("select max(price_date) from secpricelast where price_date < '%s'" % today)
	res = cur.fetchone()
	if res:
		return res[0]
	else:
		return 'None'

	
def getrepquery(reptype,today,prevday):
    return {
	'R': "select indicator, tradesignal, ticker, close_price from (select 'MACD Short' as indicator, 'Buy' as tradesignal, a.ticker,a.close_price from secpricelast a where a.ema_diff_5_35 > a.ema_macd_5 and a.price_date = '"+str(today)+"'and exists (select 1 from secpricelast p where p.ticker = a.ticker and p.price_date = '"+str(prevday)+"' and p.ema_diff_5_35 < p.ema_macd_5) union select 'MACD Short' as indicator,'Sell' as tradesignal, a.ticker,a.close_price from secpricelast a where a.ema_diff_5_35 < a.ema_macd_5 and a.price_date = '"+str(today)+"' and exists (select 1 from secpricelast p where p.ticker = a.ticker and p.price_date = '"+str(prevday)+"' and p.ema_diff_5_35 > p.ema_macd_5) union select 'MACD Long' as indicator,'Buy' as tradesignal, a.ticker,a.close_price from secpricelast a where a.ema_diff > a.ema_macd_9 and a.price_date = '"+str(today)+"' and exists (select 1 from secpricelast p where p.ticker = a.ticker and p.price_date = '"+str(prevday)+"' and p.ema_diff < p.ema_macd_9) union select 'MACD Long' as indicator,'Sell' as tradesignal, a.ticker,a.close_price from secpricelast a where a.ema_diff < a.ema_macd_9 and a.price_date = '"+str(today)+"' and exists (select 1 from secpricelast p where p.ticker = a.ticker and p.price_date = '"+str(prevday)+"' and p.ema_diff > p.ema_macd_9)) x order by x.ticker"
    }.get(reptype, 0)  

file = open("lastreport.csv","w") 
try:
	con = mdb.connect(dbhost,dbuser,dbpassword,tickmasterdb )
	cur = con.cursor()
	prevday = getprevday(cur,today)
	if (prevday == 'None'):
		print "No previous trading day data. Exiting"
	else:	
		query = getrepquery('R',today,prevday)
		cur.execute(query)
		file.write("indicator,ticker,signal,last price\n")
		for rec in cur:
			indicator = rec[0]
			signal = rec[1]
			ticker = rec[2]
			close_price = rec[3]
			line = indicator +","+ticker+","+signal+","+str(close_price) + "\n"
			file.write(line)
		file.close()
#check if email details have been setup. if so send a the report in a mail
	if (email_host and email_to and email_from):
		sendreport(email_from,email_to,email_host,'lastreport.csv')
		print "Report has been sent to all recepients"
except mdb.Error, e:

	if con:
		con.rollback()
		print "Error %d: %s" % (e.args[0],e.args[1])
		sys.exit(1)

finally:

	if con:
		con.close()
