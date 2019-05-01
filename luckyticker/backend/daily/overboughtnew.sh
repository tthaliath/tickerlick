#get today's date
NOW=$(date +"%Y-%m-%d")
export NOW='2014-06-12'

echo $NOW

/home/tthaliath/tickerlick/daily/get_prev_date.pl
export PREVDATE=`cat prevdate`
echo $PREVDATE


perl bearishquery_535_best_new.pl $NOW $PREVDATE 6 > bear/overbought_mail.csv
perl bearishquery_535_best_new.pl $NOW $PREVDATE 7 >> bear/overbought_mail.csv 
perl bearishquery_535_best_new.pl $NOW $PREVDATE 8 >> bear/overbought_mail.csv
perl bearishquery_535_best_new.pl $NOW $PREVDATE 9 >> bear/overbought_mail.csv
perl bearishquery_535_best_new.pl $NOW $PREVDATE 10 >>bear/overbought_mail.csv
perl bearishquery_535_best_new.pl $NOW $PREVDATE 11 >>bear/overbought_mail.csv
