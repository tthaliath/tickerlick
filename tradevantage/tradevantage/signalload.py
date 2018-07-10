#!/usr/bin/env python

def ReplaceNULL(x):
	if x is None:
		return 0
	elif x == '':
		return 0
	else:
		return x

def setStochasticDaily(con,cur,ticker):
	cur.execute("select count(*),max(seq),max(high_price_14),min(low_price_14) from (select seq,high_price_14,low_price_14 from secpricert b where b.ticker = '%s' order by seq desc limit 0,14) as abc" % ticker)
	res = cur.fetchone()
	if (res):
		no_of_recs = res[0]
		seq = res[1]
		max_high_price = res[2]
		min_low_price = res[3]
#process only if we have atleast  14 records 
		if (no_of_recs == 14):
# %K = 100 X ([Recent Close - Lowest Low (n)] / [Highest High (n) - Lowest low (n)])
			cur.execute("update secpricert set stc_osci_14 = 100 * ((rtq - %s)/(%s - %s)) where seq = %s" % (min_low_price,max_high_price,min_low_price,seq))
			con.commit()

def setDMAStochDaily(con,cur,ticker):
	cur.execute("SELECT avg(stc_osci_14) AS avg_stc, max(seq) as pdate,count(1) as rec_cnt FROM (SELECT stc_osci_14, seq FROM secpricert WHERE ticker = '%s' ORDER BY seq DESC LIMIT 0,3) AS abc" % ticker)
	for rec in cur:
		avg_stc= ReplaceNULL(rec[0])
		seq = rec[1]
		no_of_recs = rec[2]
#		print ticker,seq,avg_stc,no_of_recs
#process only if we have 3 records
		if (no_of_recs == 3):
			cur.execute("update secpricert set sma_3_stc_osci_14 = %s where seq = %s" %(avg_stc,seq))
			con.commit()

def setDMAStochFullDaily(con,cur,ticker):
	cur.execute("SELECT avg(sma_3_stc_osci_14) AS avg_sma_stc, max(seq) as pdate,count(1) as rec_cnt FROM (SELECT sma_3_stc_osci_14, seq from secpricert WHERE ticker = '%s' ORDER BY seq DESC LIMIT 0,3) AS abc" % ticker)
	for rec in cur:
		avg_sma_stc = ReplaceNULL(rec[0])
		seq = rec[1]
		rec_cnt = rec[2]
#		print ticker,seq,avg_sma_stc,rec_cnt
#process only if we have atleast 3 records		
		if (rec_cnt == 3): 
			cur.execute("update secpricert set sma_3_3_stc_osci_14 = %s where seq = %s" %(avg_sma_stc,seq))
			con.commit()

#process data for bollinger
def setDMABolliDaily(con,cur,ticker):
	cur.execute("SELECT avg(rtq) AS avg_rtq, max(seq) as pdate,count(1) as rec_cnt FROM (SELECT rtq, seq FROM secpricert WHERE ticker = '%s' ORDER BY seq DESC LIMIT 0,20) AS abc" % ticker)
	for rec in cur:
		avg_rtq= ReplaceNULL(rec[0])
		seq = rec[1]
		no_of_recs = rec[2]
#               print ticker,seq,avg_rtq,no_of_recs
#process only if we have 20 records
		if (no_of_recs == 20):
			cur.execute("update secpricert set dma_20 = %s where seq = %s" %(avg_rtq,seq))
			con.commit()

#process data for bollinger SD
def setDMASDBolliDaily(con,cur,ticker):
	cur.execute("SELECT SQRT(avg((rtq - dma_20) * (rtq - dma_20)))  AS dma_20_sd, max(seq) as pdate,count(1) as rec_cnt FROM (SELECT rtq, dma_20, seq FROM secpricert WHERE ticker = '%s' ORDER BY seq DESC LIMIT 0,20) AS abc" % ticker)
	for rec in cur:
		avg_dma_20= ReplaceNULL(rec[0])
                seq = rec[1]
                no_of_recs = rec[2]
#               print ticker,seq,avg_dma_20,no_of_recs
#process only if we have 20 records
		if (no_of_recs == 20):
			cur.execute("update secpricert set dma_20_sd = %s where seq = %s" %(avg_dma_20,seq))
			con.commit()
