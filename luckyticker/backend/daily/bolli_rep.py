#!/usr/bin/python

import MySQLdb as mdb
import sys

cur_date = sys.argv[1] 
print cur_date
try:
    con = mdb.connect("localhost","root","Neha*2005","tickmaster" )

    cur = con.cursor()
#bolli oversold
    bbu_query = "select ticker_id, abs((close_price - (dma_20 - (2 * dma_20_sd)))) 'bollidiff',price_date from tickerprice where  price_date = '"+cur_date+"' and close_price < (dma_20 - (2 * dma_20_sd)) order by bollidiff desc limit 50"
    cur.execute(bbu_query)
    rows = cur.fetchall()

    for row in rows:   
        cur.execute("insert into report (ticker_id,val,report_flag) VALUES (%s,%s,%s)", (row[0],row[1],'BBU'))
        cur.execute("insert into reporthistory (ticker_id,val,report_flag,report_date) VALUES (%s,%s,%s,%s)", (row[0],row[1],'BBU',row[2]))
    con.commit()       

#bolli overbought
    bbe_query = "select ticker_id, (close_price - (dma_20 + (2 * dma_20_sd))) 'bollidiff',price_date from tickerprice where  price_date = '"+cur_date+"' and close_price > abs((dma_20 + (2 * dma_20_sd))) order by bollidiff desc limit 50"
    cur.execute(bbe_query)
    rows = cur.fetchall()

    for row in rows:
        cur.execute("insert into report (ticker_id,val,report_flag) VALUES (%s,%s,%s)", (row[0],row[1],'BBE'))
        cur.execute("insert into reporthistory (ticker_id,val,report_flag,report_date) VALUES (%s,%s,%s,%s)", (row[0],row[1],'BBE',row[2]))

    con.commit()
except mdb.Error, e:
  
    if con:
        con.rollback()
        
    print "Error %d: %s" % (e.args[0],e.args[1])
    sys.exit(1)
    
finally:    
            
    if con:    
        con.close()

