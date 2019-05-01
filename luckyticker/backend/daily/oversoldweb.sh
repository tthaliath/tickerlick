#get today's date
#NOW=$(date +"%Y-%m-%d")
#export NOW='2016-12-30'
NOW=$1
echo $NOW

perl /home/tthaliath/tickerlick/daily/get_prev_date.pl
export PREVDATE=`cat /home/tthaliath/tickerlick/daily/prevdate`
#export PREVDATE='2015-12-18'
echo $PREVDATE
#perl /home/tthaliath/tickerlick/daily/deloldreportos.pl
perl /home/tthaliath/tickerlick/daily/bullishquery_535_best_web.pl $NOW $PREVDATE 6
perl /home/tthaliath/tickerlick/daily/bullishquery_535_best_web.pl $NOW $PREVDATE 7 
perl /home/tthaliath/tickerlick/daily/bullishquery_535_best_web.pl $NOW $PREVDATE 8
perl /home/tthaliath/tickerlick/daily/bullishquery_535_best_web.pl $NOW $PREVDATE 9
perl /home/tthaliath/tickerlick/daily/bullishquery_535_best_web.pl $NOW $PREVDATE 10
perl /home/tthaliath/tickerlick/daily/bullishquery_535_best_web.pl $NOW $PREVDATE 11

