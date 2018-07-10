#!/usr/bin/env python

class DMADaily:

	def __init__(self,price_date):
		self.__price_date = price_date
		self.__emaconsts = {5:0.333333 ,9:0.2, 12:0.153846, 26:0.074074, 35:0.055556}

	def setEMAStart(self,con,cur,ticker,curUpdate,offset,dmadays):
		cur.execute("SELECT avg(close_price) AS avg_prc, max(price_date) as pdate,count(1) as rec_cnt FROM (SELECT close_price, price_date FROM secpricelast WHERE ticker = '%s' ORDER BY price_date DESC LIMIT %s,%s) AS abc" % (ticker,offset,dmadays))	
		for rec in cur:
			if (rec[2] == dmadays):
				curUpdate.execute("update secpricelast set ema_" + str(dmadays) +" = %s where ticker = '%s' and price_date = '%s'" % (rec[0],ticker,rec[1]))	
				con.commit()

	def setEMAMACD535Start(self,con,cur,ticker,curUpdate):
		cur.execute("select count(1) as cnt,min(price_date) as pdate from secpricelast where ticker = '%s' and ema_diff_5_35 is not null" % ticker)
		offset = 0
		for rec in cur:
			offset = rec[0]
			price_date = rec[1]
			#print 'test0',offset,price_date
			offset = offset - 5
		if (offset >= 0):
			cur.execute("SELECT avg(ema_diff_5_35) AS avg_ema, max(price_date) as pdate,count(1) as rec_cnt FROM (SELECT ema_diff_5_35, price_date FROM secpricelast WHERE ticker = '%s' and price_date >= '%s' ORDER BY price_date DESC LIMIT %s,5) AS abc" % (ticker,price_date,offset))
			for rec in cur:
				if (rec[2] == 5):
					curUpdate.execute("update secpricelast set ema_macd_5 = %s where ticker = '%s' and price_date = '%s'" % (rec[0],ticker,rec[1]))	
					con.commit()

	def setEMAMACD1226Start(self,con,cur,ticker,curUpdate):
		cur.execute("select count(1) as cnt,min(price_date) as pdate from secpricelast where ticker = '%s' and ema_diff is not null" % ticker)
		offset = 0
		for rec in cur:
			offset = rec[0]
			price_date = rec[1]
			#print 'test0',offset,price_date
			offset = offset - 9 
			if (offset >= 0):
				cur.execute("SELECT avg(ema_diff) AS avg_ema, max(price_date) as pdate,count(1) as rec_cnt FROM (SELECT ema_diff, price_date FROM secpricelast WHERE ticker = '%s' and price_date >= '%s' ORDER BY price_date DESC LIMIT %s,9) AS abc" % (ticker,price_date,offset))
				for rec in cur:
					if (rec[2] == 9):
						curUpdate.execute("update secpricelast set ema_macd_9 = %s where ticker = '%s' and price_date = '%s'" % (rec[0],ticker,rec[1]))
						con.commit()

	def setMACD_5355(self,con,cur,ticker):
		cur.execute("update secpricelast set ema_diff_5_35 = (ema_5 - ema_35) where ticker = '%s' and  price_date = '%s'" % (ticker,self.__price_date))	
		con.commit()
	
	def setMACD_12269(self,con,cur,ticker):
		cur.execute("update secpricelast set ema_diff = (ema_12 - ema_26) where ticker = '%s' and  price_date = '%s'" % (ticker,self.__price_date)) 
		con.commit()

	def setMACD_5355Full(self,con,cur,ticker):
		cur.execute("update secpricelast set ema_diff_5_35 = (ema_5 - ema_35) where ticker = '%s'" % ticker)
		con.commit()

        def setMACD_12269Full(self,con,cur,ticker):
                cur.execute("update secpricelast set ema_diff = (ema_12 - ema_26) where ticker = '%s'" % ticker)
                con.commit()

	def setEMA(self,con,curPrev,ticker,offset,dmadays,curToday,curEMA):
  		while (offset > 0):
			#print offset,dmadays
			curPrev.execute("SELECT ema_" +str(dmadays)+" as ema_prev FROM secpricelast WHERE ticker = '%s' ORDER BY price_date DESC LIMIT %s,1" % (ticker,offset))
			for rec in curPrev:
    				ema_prev = rec[0];
 #calculate ema
 				curr_row = offset - 1;
				curToday.execute("SELECT close_price,price_date FROM secpricelast WHERE ticker = '%s' ORDER BY price_date DESC LIMIT %s,1" % (ticker,curr_row))
				for rectoday in curToday:
					curr_price = rectoday[0]
					curr_date = rectoday[1]
					#print curr_price,ema_prev,self.__emaconsts[dmadays],ema_prev
				#EMA: {Close - EMA(previous day)} x multiplier + EMA(previous day). 
					if (curr_price is not None and ema_prev is not None):
						ema = ((curr_price - ema_prev) * self.__emaconsts[dmadays]) + ema_prev;
						curEMA.execute("update secpricelast set ema_"+str(dmadays)+" = %s where ticker = '%s' and price_date = '%s'" % (ema,ticker,curr_date))
						con.commit()
			offset = offset - 1

	
	def  getoffset(self,con,cur,ticker):
		offset = 0
		cur.execute("select count(*) as cnt from secpricelast where ticker = '%s'" % ticker)
		res =  cur.fetchone()
		if (res):
			offset = res[0]
                return offset 

	def getMACDoffset(self,con,cur,ticker,fname):
	#calculate $offset
		cur.execute("select max(price_date) from secpricelast where ticker = '%s' and %s is not null" % (ticker,fname))
		price_date = "2222-12-12";
		offset = 0;
		res =  cur.fetchone()
		if (res):
			price_date = res[0]
			cur.execute("select count(1) from secpricelast where ticker = '%s' and price_date >= '%s'" % (ticker,price_date))
			res = cur.fetchone()
			if (res):
				offset = res[0]
		#print 'test2:',offset
		return offset

	def setEMAMACD535(self,con,cur,ticker,offset,cur_ema_diff,cur_ema_macd):
		while (offset > 0):
			cur.execute("SELECT ema_macd_5 as ema_macd_prev FROM secpricelast WHERE ticker = '%s' ORDER BY price_date DESC LIMIT %s,1" % (ticker,offset))	
			for rec in cur:
				ema_macd_prev = rec[0]
				curr_row = offset - 1
				cur_ema_diff.execute("SELECT ema_diff_5_35,price_date FROM secpricelast WHERE ticker = '%s' ORDER BY price_date DESC LIMIT %s,1" % (ticker,curr_row))
				for rec_ema_diff in cur_ema_diff:
					curr_macd = rec_ema_diff[0]
					curr_date = rec_ema_diff[1]
				  	#EMA: {Close - EMA(previous day)} x multiplier + EMA(previous day).
					if (curr_macd is not None and ema_macd_prev is not None):
						#print curr_macd, ema_macd_prev,self.__emaconsts[5]
				     		ema_macd = ((curr_macd - ema_macd_prev) * self.__emaconsts[5]) + ema_macd_prev;	
						cur_ema_macd.execute("update secpricelast set ema_macd_5 = %s where ticker = '%s' and price_date = '%s'" % (ema_macd,ticker,curr_date))
						con.commit()
			offset = offset - 1


	def setEMAMACD1226(self,con,cur,ticker,offset,cur_ema_diff,cur_ema_macd):
		while (offset > 0):
			cur.execute("SELECT ema_macd_9 as ema_macd_prev FROM secpricelast WHERE ticker = '%s' ORDER BY price_date DESC LIMIT %s,1" % (ticker,offset))
			for rec in cur:
				ema_macd_prev = rec[0]
				curr_row = offset - 1
				cur_ema_diff.execute("SELECT ema_diff,price_date FROM secpricelast WHERE ticker = '%s' ORDER BY price_date DESC LIMIT %s,1" % (ticker,curr_row))
				for rec_ema_diff in cur_ema_diff:
					curr_macd = rec_ema_diff[0]
					curr_date = rec_ema_diff[1]
					#EMA: {Close - EMA(previous day)} x multiplier + EMA(previous day).
					if (curr_macd is not None and ema_macd_prev is not None):
						#print curr_macd, ema_macd_prev,self.__emaconsts[5]
						ema_macd = ((curr_macd - ema_macd_prev) * self.__emaconsts[9]) + ema_macd_prev;
						cur_ema_macd.execute("update secpricelast set ema_macd_9 = %s where ticker = '%s' and price_date = '%s'" % (ema_macd,ticker,curr_date))
						con.commit()
			offset = offset - 1
