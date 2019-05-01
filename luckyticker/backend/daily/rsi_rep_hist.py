#!/usr/bin/python

import MySQLdb as mdb
import sys

cur_date = sys.argv[1] 
try:
    con = mdb.connect("localhost","root","Neha*2005","tickmaster" )

    cur = con.cursor()
    os_query = "select a.ticker_id,rsi_14,b.price_date from tickermaster a, tickerpricersi b where a.ticker_id = b.ticker_id and b.price_date = '"+cur_date+"'  and rsi_14 > 3 and rsi_14 < 35 and  close_price > 5 order by rsi_14 asc"
    cur.execute(os_query)
    rows = cur.fetchall()

    for row in rows:   
        #ins_sql = "insert into report (ticker_id,val,report_flag) values (row[0],row[1],'RS')"; 
        #cur.execute("insert into report (ticker_id,val,report_flag) VALUES ('$d','%f','%s') %(row[0],row[1],'RS')")
        cur.execute("insert into reporthistory (ticker_id,val,report_flag,report_date) VALUES (%s,%s,%s,%s)", (row[0],row[1],'RS',row[2]))
    con.commit()       

#rsi overbought
    ob_query = "select a.ticker_id,rsi_14,b.price_date from tickermaster a, tickerpricersi b where a.ticker_id = b.ticker_id and b.price_date = '"+cur_date+"'   and rsi_14 > 75 and rsi_14 < 95 and  close_price > 5 order by rsi_14 desc"
    cur.execute(ob_query)
    rows = cur.fetchall()

    for row in rows:
        #ins_sql = "insert into report (ticker_id,val,report_flag) values (row[0],row[1],'RS')";
        #cur.execute("insert into report (ticker_id,val,report_flag) VALUES ('$d','%f','%s') %(row[0],row[1],'RS')")
        cur.execute("insert into reporthistory (ticker_id,val,report_flag,report_date) VALUES (%s,%s,%s,%s)", (row[0],row[1],'RB',row[2]))
    con.commit()
except mdb.Error, e:
  
    if con:
        con.rollback()
        
    print "Error %d: %s" % (e.args[0],e.args[1])
    sys.exit(1)
    
finally:    
            
    if con:    
        con.close()

