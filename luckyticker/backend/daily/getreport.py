#!/usr/local/bin/python

import MySQLdb as mdb
import sys


try:
    con = mdb.connect("localhost","root","Neha*2005","tickmaster" )

    cur = con.cursor()
    cur.execute("select ticker_id from  report")
    con.commit()

    
except mdb.Error, e:
  
    if con:
        con.rollback()
        
    print "Error %d: %s" % (e.args[0],e.args[1])
    sys.exit(1)
    
finally:    
            
    if con:    
        con.close()

