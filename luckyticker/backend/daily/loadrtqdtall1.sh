NOW=$(date +"%Y-%m-%d")
#export NOW='2018-11-07'
#NOW=$1
#echo $NOW
perl /home/tthaliath/tickerlick/daily/get_prev_date_rtq.pl $NOW
export PREVDATE=`cat /home/tthaliath/tickerlick/daily/prevdatertq`
#echo $PREVDATE
counter=1
while [ $counter -le 225 ]
do
/usr/local/bin/python /home/tthaliath/tickerlick/history/rtq/python/get_yahoo_quote_final.py EBAY,AAPL,AMD,NVDA,AMZN $NOW $PREVDATE
/usr/bin/perl /home/tthaliath/tickerlick/history/rtq/perlcalllist1.pl EBAY,AAPL,AMD,NVDA,AMZN $NOW $PREVDATE
/usr/local/bin/python /home/tthaliath/tickerlick/tradevantage/reportquery.py
((counter++))
done
echo "DONE"

