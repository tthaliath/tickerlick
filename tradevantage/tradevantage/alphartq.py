#!/usr/bin/env python

import MySQLdb as mdb
import sys
import os
import requests
import re
from signalload import ReplaceNULL,setStochasticDaily,setDMAStochDaily,setDMAStochFullDaily,setDMABolliDaily,setDMASDBolliDaily
import json
from optparse import OptionParser
import time
## yyyy-mm-dd format
import datetime
mylist = []
today = datetime.date.today()
mylist.append(today)
today = mylist[0] # print the date object, not the container ;-)
def getsymbolsfromfile(symbolfile):
	symbollist='';
	if symbolfile is None:
		return 0
	elif symbolfile == '':
		return 0
	else:
		tick = '';
		with open(symbolfile, "r") as f:
			for line in f:
				line = line.strip()
				tick = tick + "," + line
		tick = tick[1:]
		return tick

def isBlank (tickerlist):
	if tickerlist and tickerlist.strip():
#tickerlist is not None and tickerlist is not empty or blank
		return tickerlist 
	#myString is None OR myString is empty or blank. Then return default ticker AAPL
	return 'AAPL' 

if __name__ == "__main__":
	parser = OptionParser()
	parser.add_option("-t",dest="symbollist", help="symbols of US securities separated by comma (no spaces)")
	parser.add_option("-f",dest="symbolfile",help="security symbol file (one per line)",default="symbollist.txt")
	parser.add_option("-d",dest="currdate",help="day of trading",default=today)
	(options, args) = parser.parse_args()
	tickerlist = ""
	if (options.symbollist):
		print "taking symbols from command line"
		tickerlist = options.symbollist
	elif (options.symbolfile):
		print "taking symbols from file"
	else:
		print "using default ticker AAPL"
		tickerlist = 'AAPL'
#make sure that tickerlist s not blank and has atleast one symbol. tickerlist can be blank if symbols file is blank.
	tickerlist = isBlank(tickerlist)
	if (options.currdate):
		price_date = options.currdate
        else:
		price_date = today

json_data = json.load(open('config.json'))
dbhost = json_data['mysql']['host']
dbuser = json_data['mysql']['user']
dbpassword = json_data['mysql']['passwd']
tickmasterdb = json_data['mysql']['db']
apikey = json_data['apikey']['alphaapikey']
try:
	con = mdb.connect(dbhost,dbuser,dbpassword,tickmasterdb )
	cur = con.cursor()
	for ticker in (tickerlist.split(",")):
		yurl = "http://www.alphavantage.co/query?apikey="+apikey+"&function=TIME_SERIES_INTRADAY&interval=1min&symbol="+ticker
		req = requests.get(yurl)
		the_page = req.content
		pat = re.compile(r'.*?Time Series.*?high\".*?\"(.*?)\".*?low\".*?\"(.*?)\".*?close\".*?\"(.*?)\"',re.M|re.S)
		mo = pat.search(the_page)
		if mo is None:
			print ticker + ":no match from alphavantage. trying marketwatch"
			yurl = "http://www.marketwatch.com/investing/stock/"+ticker;
			req = requests.get(yurl)
			the_page = req.content
			pat = re.compile(r'class\=\"intraday__price.*?<bg-quote.*?>(.*?)<\/bg-quote>.*?precision.*?day\-open.*?range\-low\=\"(.*?)\".*?range\-high\=\"(.*?)\"',re.M|re.S)
			mo = pat.search(the_page)
			if mo is None:	
				print "no match"
			else:
				cur.execute("insert into secpricert (ticker,price_date,rtq,low_price_14,high_price_14) VALUES (%s,%s,%s,%s,%s)", (ticker,price_date,mo.group(1),mo.group(2),mo.group(3)))	
				con.commit()
		else:
			cur.execute("insert into secpricert (ticker,price_date,rtq,low_price_14,high_price_14) VALUES (%s,%s,%s,%s,%s)", (ticker,price_date,mo.group(3),mo.group(2),mo.group(1)))
			con.commit()
#update  gain/loss based on previous price
	for ticker in (tickerlist.split(",")):
		cur.execute("select seq,rtq from secpricert where ticker  = '%s' order by seq desc limit 1,1" % ticker)
		res = cur.fetchone()
		if (res):
			prev_seq = res[0]
			prev_rtq = res[1]
			cur.execute("select seq,rtq from secpricert where ticker = '%s' and seq > %s" % (ticker,prev_seq))
                        for rec in cur:
				seq = rec[0]
				rtq = rec[1]
				gain = 0
				loss = 0
				if (rtq > prev_rtq):
					gain = rtq - prev_rtq
					loss = 0
				else:
					loss = prev_rtq - rtq
					gain = 0
				prev_rtq = rtq
				cur.execute("update secpricert set gain = %s, loss = %s where seq = %s" % (gain,loss,seq))
				con.commit()
#update avg gain/avg loss
	for ticker in (tickerlist.split(",")):
		cur.execute("select avg_gain,avg_loss,seq from secpricert where ticker  = '%s' order by seq desc limit 1,1" % ticker)	
		res = cur.fetchone()
		prev_avg_gain = 0
		prev_avg_loss = 0
		if (res):
			prev_avg_gain = ReplaceNULL(res[0])
			prev_avg_loss = ReplaceNULL(res[1])
		cur.execute("select gain,loss,seq from secpricert where ticker = '%s' order by seq desc limit 1" % ticker)
		res = cur.fetchone()
		if (res):
			curr_gain = res[0]
			curr_loss = res[1]
			curr_seq = res[2]
			avg_gain = ((prev_avg_gain  * 13.00) + curr_gain) / 14.00
       			avg_loss = ((prev_avg_loss  * 13.00) + curr_loss) / 14.00
       			if (avg_gain == 0):
				rs = 0
				rsi = 0
			
			elif (avg_loss == 0):
				rs = 100
				rsi = 100
			else:
				rs = avg_gain/avg_loss
				rsi = 100.00 - (100.00/(1.00+rs))
#			print ticker,curr_seq,prev_avg_gain,prev_avg_loss,curr_gain,curr_loss,avg_gain,avg_loss,rs,rsi
			cur.execute("update secpricert set avg_gain = %s, avg_loss = %s ,rsi = %s, rsi_14 = %s where seq = %s" % (avg_gain,avg_loss,rs,rsi,curr_seq))
			con.commit()
	
	for ticker in (tickerlist.split(",")):	
		setStochasticDaily(con,cur,ticker)
		setDMAStochDaily(con,cur,ticker)
		setDMAStochFullDaily(con,cur,ticker)
		setDMABolliDaily(con,cur,ticker)
		setDMASDBolliDaily(con,cur,ticker)
except mdb.Error, e:

	if con:
		con.rollback()
		print "Error %d: %s" % (e.args[0],e.args[1])
		sys.exit(1)

finally:

	if con:
		con.close()
