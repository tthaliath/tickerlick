#!/usr/bin/python

import MySQLdb as mdb
import sys

cur_date = sys.argv[1]
print cur_date

try:
    con = mdb.connect("localhost","root","Neha*2005","tickmaster" )

    cur = con.cursor()
    os_query = "select a.ticker_id,b.sma_3_3_stc_osci_14 from tickermaster a, tickerprice b where (a.sector in ('Basic Materials','Global Equity ETF','US Equity ETF','Technology','Financial','Services') or a.ticker = 'GLD') and (a.industry NOT REGEXP '^Specialty' and a.industry NOT REGEXP '^Shipping' and a.industry NOT REGEXP '^Rental' and a.industry NOT REGEXP '^Agricultural' and a.industry NOT REGEXP '^Specialty' and a.industry NOT REGEXP '^Air' and a.industry NOT REGEXP '^Education' and a.industry NOT REGEXP '^Savings' and a.industry NOT REGEXP '^Closed-End' and a.industry NOT REGEXP '^Regional' and a.industry NOT REGEXP '^Property' and a.industry NOT REGEXP '^REIT' and a.industry NOT REGEXP '^Auto' and a.industry NOT REGEXP '^Building') and a.ticker_id = b.ticker_id and b.price_date = '"+cur_date+"'   and sma_3_3_stc_osci_14 > 10 and sma_3_3_stc_osci_14 <= 30 and  close_price > 5 order by sma_3_3_stc_osci_14 asc"

    cur.execute(os_query)
    rows = cur.fetchall()

    for row in rows:   
        #ins_sql = "insert into report (ticker_id,val,report_flag) values (row[0],row[1],'RS')"; 
        #cur.execute("insert into report (ticker_id,val,report_flag) VALUES ('$d','%f','%s') %(row[0],row[1],'RS')")
        cur.execute("insert into report (ticker_id,val,report_flag) VALUES (%s,%s,%s)", (row[0],row[1],'SS'))

    con.commit()       

#stoch overbought
    ob_query = "select a.ticker_id,b.sma_3_3_stc_osci_14 from tickermaster a, tickerprice b where (a.sector in ('Basic Materials','Global Equity ETF','US Equity ETF','Technology','Financial','Services') or a.ticker = 'GLD') and (a.industry NOT REGEXP '^Specialty' and a.industry NOT REGEXP '^Shipping' and a.industry NOT REGEXP '^Rental' and a.industry NOT REGEXP '^Agricultural' and a.industry NOT REGEXP '^Specialty' and a.industry NOT REGEXP '^Air' and a.industry NOT REGEXP '^Education' and a.industry NOT REGEXP '^Savings' and a.industry NOT REGEXP '^Closed-End' and a.industry NOT REGEXP '^Regional' and a.industry NOT REGEXP '^Property' and a.industry NOT REGEXP '^REIT' and a.industry NOT REGEXP '^Auto' and a.industry NOT REGEXP '^Building') and a.ticker_id = b.ticker_id and b.price_date = '"+cur_date+"'   and sma_3_3_stc_osci_14 > 80 and sma_3_3_stc_osci_14 < 95 and  close_price > 5 order by sma_3_3_stc_osci_14 desc"

    cur.execute(ob_query)
    rows = cur.fetchall()

    for row in rows:
        #ins_sql = "insert into report (ticker_id,val,report_flag) values (row[0],row[1],'RS')";
        #cur.execute("insert into report (ticker_id,val,report_flag) VALUES ('$d','%f','%s') %(row[0],row[1],'RS')")
        cur.execute("insert into report (ticker_id,val,report_flag) VALUES (%s,%s,%s)", (row[0],row[1],'SB'))

    con.commit()
except mdb.Error, e:
  
    if con:
        con.rollback()
        
    print "Error %d: %s" % (e.args[0],e.args[1])
    sys.exit(1)
    
finally:    
            
    if con:    
        con.close()

