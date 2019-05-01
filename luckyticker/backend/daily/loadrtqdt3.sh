#get today's date
NOW=$(date +"%Y-%m-%d")
#export NOW='2018-01-19'

#echo $NOW

/usr/local/bin/python /home/tthaliath/tickerlick/history/rtq/python/alphartqnewmw3.py BABA,BIDU,CMG,CRM,JPM,MDB,MU,SNAP,SYMC,T,WMT 
#/usr/local/bin/python /home/tthaliath/tickerlick/tradevantage/reportquery.py
echo "DONE"

