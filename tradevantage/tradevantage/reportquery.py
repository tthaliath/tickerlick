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
json_data = json.load(open('config.json'))
dbhost = json_data['mysql']['host']
dbuser = json_data['mysql']['user']
dbpassword = json_data['mysql']['passwd']
tickmasterdb = json_data['mysql']['db']
#email details
email_host =  json_data['email']['smtplibhost']
email_to = json_data['email']['To']
email_from = json_data['email']['From']

def getrepquery(reptype):
	return {
	'R': "select indicator, tradesignal, ticker, rtq, rsi_14,sma_3_3_stc_osci_14 from (select 'RSI' as indicator,'Buy' as tradesignal ,d.ticker,d.rtq,d.rsi_14,d.sma_3_3_stc_osci_14 from secpricert d,(select a.ticker,max(a.seq) maxseq from secpricert a where a.price_date = '"+today+"' group by a.ticker) b where d.seq = b.maxseq and d.ticker = b.ticker  and d.rsi_14 < 25  and d.rsi_14 != 0 union select 'RSI' as indicator, 'Sell'as tradesignal,d.ticker,d.rtq,d.rsi_14,d.sma_3_3_stc_osci_14 from secpricert d,(select a.ticker,max(a.seq) maxseq from secpricert a where a.price_date = '"+today+"' group by a.ticker) b where d.seq = b.maxseq and d.ticker = b.ticker  and d.rsi_14 > 75  and d.rsi_14 != 0 union select 'Stochastic' as indicator,  'Buy' as tradesignal ,d.ticker,d.rtq,d.rsi_14,d.sma_3_3_stc_osci_14 from secpricert d,(select a.ticker,max(a.seq) maxseq from secpricert a where a.price_date = '"+today+"' group by a.ticker) b where d.seq = b.maxseq and d.ticker = b.ticker  and d.sma_3_3_stc_osci_14 < 20 and d.sma_3_3_stc_osci_14  >  1 union select 'Stochastic' as indicator, 'Sell' as tradesignal,d.ticker,d.rtq,d.rsi_14,d.sma_3_3_stc_osci_14 from secpricert d,(select a.ticker,max(a.seq) maxseq from secpricert a where a.price_date = '"+today+"' group by a.ticker) b where d.seq = b.maxseq and d.ticker = b.ticker  and d.sma_3_3_stc_osci_14 > 80 and d.sma_3_3_stc_osci_14 < 99 union select 'Bollinger Band' as indicator, 'Buy' as tradesignal, d.ticker,d.rtq, d.rsi_14,abs((d.rtq - (d.dma_20 - (2 * d.dma_20_sd)))) 'bollidiff' from secpricert d,(select a.ticker,max(a.seq) maxseq from secpricert a where a.price_date = '"+today+"' group by a.ticker) b where d.seq = b.maxseq and d.ticker = b.ticker and d.rtq < (d.dma_20 - (2 * d.dma_20_sd)) union select 'Bollinger Band' as indicator, 'Sell' as tradesignal,d.ticker,d.rtq,d.rsi_14, abs((d.rtq - (d.dma_20 + (2 * d.dma_20_sd)))) 'bollidiff' from secpricert d,(select a.ticker,max(a.seq) maxseq from secpricert a where a.price_date = '"+today+"' group by a.ticker) b where d.seq = b.maxseq and d.ticker = b.ticker and d.rtq > abs((d.dma_20 + (2 * d.dma_20_sd)))) x order by x.ticker"
 }.get(reptype, 0)

query = getrepquery('R')
file = open("lastreport.csv","w") 
#print query
try:
	con = mdb.connect(dbhost,dbuser,dbpassword,tickmasterdb )
	cur = con.cursor()
	cur.execute(query)
	file.write("ticker,indicator,signal,last price\n")
	for rec in cur:
		indicator = rec[0]
		signal = rec[1]
		ticker = rec[2]
		rtq = rec[3]
		rsi = rec[4]
		stoch = rec[5]
		line = ticker +","+indicator+","+signal+","+str(rtq) + "\n"
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
