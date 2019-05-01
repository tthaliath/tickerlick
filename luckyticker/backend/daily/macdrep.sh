#NOW=$(date +"%Y-%m-%d")
#export NOW='2015-12-30'
NOW=$1
echo $NOW
perl /home/tthaliath/tickerlick/daily/get_prev_date1.pl
export PREVDATE=`cat /home/tthaliath/tickerlick/daily/prevdate1`
#export PREVDATE='2015-12-29'
echo $PREVDATE
perl /home/tthaliath/tickerlick/daily/bullishquery_5355.pl $NOW $PREVDATE
perl /home/tthaliath/tickerlick/daily/bullishquery_12926.pl $NOW $PREVDATE
perl /home/tthaliath/tickerlick/daily/bearishquery_5355.pl $NOW $PREVDATE
perl /home/tthaliath/tickerlick/daily/bearishquery_12926.pl $NOW $PREVDATE
perl /home/tthaliath/tickerlick/daily/macd_bullish_os.pl $NOW $PREVDATE  
perl /home/tthaliath/tickerlick/daily/macd_bearish_ob.pl $NOW $PREVDATE
