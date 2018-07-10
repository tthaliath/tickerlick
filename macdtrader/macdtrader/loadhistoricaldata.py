#!/usr/bin/env python

from datetime import datetime, timedelta
import requests
import csv
import sys

class LoadPriceHistory:

	def __init__(self,daysago):
		self.__date_N_days_ago = datetime.now() - timedelta(days=daysago)

	def processhistoricalprice(self,con,cur,ticker):
		end_date = datetime.now().strftime('%Y-%m-%d')
		start_date = self.__date_N_days_ago.strftime('%Y-%m-%d')
		yurl = "http://finance.google.com/finance/historical?q="+ticker+"&startdate="+start_date+"&enddate="+end_date+"&num=self.__date_N_days_ago&output=csv"
		#print yurl
		req = requests.get(yurl)
		the_page = req.content.rstrip()
		#save the html into temp file
		orig_stdout = sys.stdout
		f = open('out.csv', 'w')
		sys.stdout = f
		print the_page
		sys.stdout = orig_stdout
		f.close()
		firstline = 1
		with open('out.csv') as csvfile:
			readCSV = csv.reader(csvfile, delimiter=',')
			for row in readCSV:
				if (firstline):
					firstline = 0
				else:
					p = row[0].rstrip()
					price_date = datetime.strptime(p,"%d-%b-%y").strftime('%Y-%m-%d')
					#print ticker, price_date,row[4],row[3],row[2]
					cur.execute("replace into secpricelast (ticker,price_date,close_price,low_price,high_price) VALUES (%s,%s,%s,%s,%s)", (ticker,price_date,row[4],row[3],row[2]))
	
					con.commit()
