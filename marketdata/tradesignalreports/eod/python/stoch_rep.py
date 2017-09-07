#!/usr/bin/python

import MySQLdb as mdb
import sys
import os
dbpassword = os.environ['DBPASSWORD']
cur_date = sys.argv[1]

try:
    con = mdb.connect("localhost","root",dbpassword,"tickmaster" )

    cur = con.cursor()
    os_query = "select a.ticker_id,b.sma_3_3_stc_osci_14,b.price_date from tickermaster a, tickerprice b where a.ticker_id = b.ticker_id and b.price_date = '"+cur_date+"'   and sma_3_3_stc_osci_14 < 20 and sma_3_3_stc_osci_14 > 1 and close_price > 5 order by sma_3_3_stc_osci_14 asc"

    cur.execute(os_query)
    rows = cur.fetchall()

    for row in rows:   
        #ins_sql = "insert into report (ticker_id,val,report_flag) values (row[0],row[1],'RS')"; 
        #cur.execute("insert into report (ticker_id,val,report_flag) VALUES ('$d','%f','%s') %(row[0],row[1],'RS')")
        cur.execute("insert into report (ticker_id,val,report_flag) VALUES (%s,%s,%s)", (row[0],row[1],'SS'))
        cur.execute("insert into reporthistory (ticker_id,val,report_flag,report_date) VALUES (%s,%s,%s,%s)", (row[0],row[1],'SS',row[2]))
    con.commit()       

#stoch overbought
    ob_query = "select a.ticker_id,b.sma_3_3_stc_osci_14,b.price_date from tickermaster a, tickerprice b where a.ticker_id = b.ticker_id  and b.price_date = '"+cur_date+"'   and sma_3_3_stc_osci_14 > 80 and sma_3_3_stc_osci_14 < 99 and close_price > 5 order by sma_3_3_stc_osci_14 desc"

    cur.execute(ob_query)
    rows = cur.fetchall()

    for row in rows:
        #ins_sql = "insert into report (ticker_id,val,report_flag) values (row[0],row[1],'RS')";
        #cur.execute("insert into report (ticker_id,val,report_flag) VALUES ('$d','%f','%s') %(row[0],row[1],'RS')")
        cur.execute("insert into report (ticker_id,val,report_flag) VALUES (%s,%s,%s)", (row[0],row[1],'SB'))
        cur.execute("insert into reporthistory (ticker_id,val,report_flag,report_date) VALUES (%s,%s,%s,%s)", (row[0],row[1],'SB',row[2]))
    con.commit()
except mdb.Error, e:
  
    if con:
        con.rollback()
        
    print "Error %d: %s" % (e.args[0],e.args[1])
    sys.exit(1)
    
finally:    
            
    if con:    
        con.close()

