#!/usr/bin/python

import MySQLdb as mdb
import sys
#$sql = "select 'OS', c.ticker,c.comp_name, c.sector,a.price_date, a.close_price, (ema_diff_5_35 - ema_macd_5) as MACD,sma_3_3_stc_osci_14 as Stochastic,b.rsi_14 as RSI, dma_20_sd, (((dma_20 + (2 * dma_20_sd))) - ((dma_20 -  (2 * dma_20_sd)))) 'BOLLINGER', b.rsistoch_14 from tickerprice a, tickerpricersi b, tickermaster c  where a.price_date = '$day' and c.ticker_id = a.ticker_id and a.ticker_id = b.ticker_id and a.price_date = b.price_date  and (a.close_price - (dma_20 - (2 * dma_20_sd))) < 0 and rsistoch_14 < 0.25 and c.tflag2 = 'Y' union  select  'OB', c.ticker,c.comp_name, c.sector,a.price_date, a.close_price, (ema_diff_5_35 - ema_macd_5) as MACD,sma_3_3_stc_osci_14 as Stochastic,b.rsi_14 as RSI, dma_20_sd, (((dma_20 + (2 * dma_20_sd))) - ((dma_20 -  (2 * dma_20_sd)))) 'BOLLINGER', b.rsistoch_14 from tickerprice a, tickerpricersi b, tickermaster c  where a.price_date = '$day' and c.ticker_id = a.ticker_id and a.ticker_id = b.ticker_id and a.price_date = b.price_date  and ((dma_20 + (2 * dma_20_sd)) - a.close_price ) < 0 and rsistoch_14 > 0.75 and c.tflag2 =  'Y'";

cur_date = sys.argv[1]

try:
    con = mdb.connect("localhost","root","Neha*2005","tickmaster" )

    cur = con.cursor()
    os_query = "select a.ticker_id,rsistoch_14,b.price_date from tickermaster a, tickerprice b,tickerpricersi c where a.ticker_id = b.ticker_id and b.price_date = '"+cur_date+"' and b.ticker_id = c.ticker_id and b.price_date = c.price_date and b.close_price > 5  and (b.close_price - (dma_20 - (2 * dma_20_sd))) < 0 and rsistoch_14 < 0.20  order by rsistoch_14 asc"

    cur.execute(os_query)
    rows = cur.fetchall()

    for row in rows:   
        cur.execute("insert into report (ticker_id,val,report_flag) VALUES (%s,%s,%s)", (row[0],row[1],'SSR'))
        cur.execute("insert into reporthistory (ticker_id,val,report_flag,report_date) VALUES (%s,%s,%s,%s)", (row[0],row[1],'SSR',row[2]))
    con.commit()       

#stoch overbought
    ob_query = "select a.ticker_id,rsistoch_14,b.price_date from tickermaster a, tickerprice b,tickerpricersi c where a.ticker_id = b.ticker_id and b.price_date = '"+cur_date+"' and b.ticker_id = c.ticker_id and b.price_date = c.price_date and b.close_price > 5  and ((dma_20 + (2 * dma_20_sd)) - b.close_price ) and rsistoch_14 > 0.80  order by rsistoch_14 desc"

    cur.execute(ob_query)
    rows = cur.fetchall()

    for row in rows:
        cur.execute("insert into report (ticker_id,val,report_flag) VALUES (%s,%s,%s)", (row[0],row[1],'SBR'))
        cur.execute("insert into reporthistory (ticker_id,val,report_flag,report_date) VALUES (%s,%s,%s,%s)", (row[0],row[1],'SBR',row[2]))
    con.commit()
except mdb.Error, e:
  
    if con:
        con.rollback()
        
    print "Error %d: %s" % (e.args[0],e.args[1])
    sys.exit(1)
    
finally:    
            
    if con:    
        con.close()

