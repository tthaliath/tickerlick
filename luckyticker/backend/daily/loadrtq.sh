#get today's date
NOW=$(date +"%Y-%m-%d")
#export NOW='2018-01-19'

#echo $NOW

/usr/local/bin/python /home/tthaliath/tickerlick/history/rtq/python/alphartqnewmw.py EBAY,AAPL,AMD,NVDA,AMZN,TSLA,FB,NFLX,AGN,QCOM,SQ,TWTR,SPY,QQQ,GOOGL,AAL,GE,AA
#/usr/local/bin/python /home/tthaliath/tickerlick/tradevantage/reportquery.py
echo "DONE"

