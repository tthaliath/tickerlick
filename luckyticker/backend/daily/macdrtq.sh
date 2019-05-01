NOW=$(date +"%Y-%m-%d")
#export NOW='2015-12-30'
#NOW=$1
#echo $NOW
perl /home/tthaliath/tickerlick/daily/get_prev_date_rtq.pl $NOW
export PREVDATE=`cat /home/tthaliath/tickerlick/daily/prevdatertq`
#export PREVDATE='2015-12-29'
#echo $PREVDATE
