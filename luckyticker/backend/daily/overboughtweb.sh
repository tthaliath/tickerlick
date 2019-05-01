#get today's date
#NOW=$(date +"%Y-%m-%d")
#export NOW='2016-12-30'
NOW=$1
echo $NOW

/home/tthaliath/tickerlick/daily/get_prev_date.pl
export PREVDATE=`cat /home/tthaliath/tickerlick/daily/prevdate`
#export PREVDATE='2015-12-18'
echo $PREVDATE
#/home/tthaliath/tickerlick/daily/deloldreportob.pl
/home/tthaliath/tickerlick/daily/bearishquery_535_best_web.pl $NOW $PREVDATE 6
/home/tthaliath/tickerlick/daily/bearishquery_535_best_web.pl $NOW $PREVDATE 7 
/home/tthaliath/tickerlick/daily/bearishquery_535_best_web.pl $NOW $PREVDATE 8
/home/tthaliath/tickerlick/daily/bearishquery_535_best_web.pl $NOW $PREVDATE 9
/home/tthaliath/tickerlick/daily/bearishquery_535_best_web.pl $NOW $PREVDATE 10
/home/tthaliath/tickerlick/daily/bearishquery_535_best_web.pl $NOW $PREVDATE 11
