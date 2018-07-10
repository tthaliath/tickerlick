#!/usr/bin/env python

import MySQLdb as mdb
import sys
import os
import requests
import re
from DMA import DMADaily
from loadhistoricaldata import LoadPriceHistory
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
dma = DMADaily(price_date)
ph = LoadPriceHistory(60)
try:
	con = mdb.connect(dbhost,dbuser,dbpassword,tickmasterdb )
	cur = con.cursor()
	curToday = con.cursor()
	curEMA = con.cursor()
	cur_ema_diff = con.cursor()
	cur_ema_macd = con.cursor()
	cur_sec_master = con.cursor()
	for ticker in (tickerlist.split(",")):
		print ticker
		#check if the ticker is new. If so, load prior two months historical price and process it.
		cur_sec_master.execute("select signal_process_flag from securitymaster where ticker  = '%s'" % ticker)
		res = cur_sec_master.fetchone()
		if (res):
			if (res[0] == 'N'):
				print "New ticker. Loading historical data first"
				ph.processhistoricalprice(con,cur,ticker)
			#set the flag to Y
				cur_sec_master.execute("update securitymaster set signal_process_flag = 'Y' where ticker  = '%s'" % ticker)
				con.commit()	
		else:
			print "New ticker. Adding into securitymaster table and then loading historical data"
			cur_sec_master.execute("insert into securitymaster (ticker,signal_process_flag) VALUES (%s,%s)", (ticker,'Y'))
			ph.processhistoricalprice(con,cur,ticker)
			con.commit()
		#process today's price`
		yurl = "http://www.marketwatch.com/investing/stock/"+ticker;
		req = requests.get(yurl)
		the_page = req.content
		pat = re.compile(r'class\=\"intraday__price.*?<bg-quote.*?>(.*?)<\/bg-quote>.*?precision.*?day\-open.*?range\-low\=\"(.*?)\".*?range\-high\=\"(.*?)\"',re.M|re.S)
		mo = pat.search(the_page)
		if mo is None:	
			print "no match"
		else:
			cur.execute("replace into secpricelast (ticker,price_date,close_price,low_price,high_price) VALUES (%s,%s,%s,%s,%s)", (ticker,price_date,mo.group(1),mo.group(2),mo.group(3)))	
			con.commit()
	for ticker in (tickerlist.split(",")):	
		#print "Calculating short MACD (5-35-5)\n"
		#print "Calculating EMA5\n"
		offsetmain = dma.getoffset(con,cur,ticker)
		if (offsetmain < 35):
			print "insufficient data to calculate signals,"+ticker+"\n"
			continue
		offset = offsetmain - 5 
		dmaday = 5
		dma.setEMAStart(con,cur,ticker,curEMA,offset,dmaday)
		dma.setEMA(con,cur,ticker,offset,dmaday,curToday,curEMA)
		#print "Calculating EMA35\n"
		offset = offsetmain - 35 
                dmaday = 35	
		dma.setEMAStart(con,cur,ticker,curEMA,offset,dmaday)
		dma.setEMA(con,cur,ticker,offset,dmaday,curToday,curEMA)
		#print "Calculating MACD line\n"
		dma.setMACD_5355Full(con,cur,ticker)
		#print "Calculating signal line\n"
		dma.setEMAMACD535Start(con,cur,ticker,cur_ema_macd)
		macdoffset = dma.getMACDoffset(con,cur,ticker,'ema_macd_5')
		if (macdoffset > 0):
			dma.setEMAMACD535(con,cur,ticker,macdoffset,cur_ema_diff,cur_ema_macd)	
		
		#print "Calculating long MACD (12-26-9)\n"
		#print "Calculating EMA12\n"
		offset = offsetmain - 12 
		dmaday = 12 
		dma.setEMAStart(con,cur,ticker,curEMA,offset,dmaday)
		dma.setEMA(con,cur,ticker,offset,dmaday,curToday,curEMA)
		#print "Calculating EMA26\n"
		offset = offsetmain - 26 
		dmaday = 26 
		dma.setEMAStart(con,cur,ticker,curEMA,offset,dmaday)
		dma.setEMA(con,cur,ticker,offset,dmaday,curToday,curEMA)
		#print "Calculating MACD line\n"
		dma.setMACD_12269Full(con,cur,ticker)
		#print "Calculating signal line\n"
		dma.setEMAMACD1226Start(con,cur,ticker,cur_ema_macd)
		macdoffset = dma.getMACDoffset(con,cur,ticker,'ema_macd_9')
		if (macdoffset > 0):
			dma.setEMAMACD1226(con,cur,ticker,macdoffset,cur_ema_diff,cur_ema_macd)
	
except mdb.Error, e:

	if con:
		con.rollback()
		print "Error %d: %s" % (e.args[0],e.args[1])
		sys.exit(1)

finally:

	if con:
		con.close()
