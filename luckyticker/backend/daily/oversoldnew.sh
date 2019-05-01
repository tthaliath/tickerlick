#get today's date
NOW=$(date +"%Y-%m-%d")
export NOW='2014-06-12'

echo $NOW

/home/tthaliath/tickerlick/daily/get_prev_date.pl
export PREVDATE=`cat prevdate`
echo $PREVDATE

perl bullishquery_535_best_new.pl $NOW $PREVDATE 6 > bull/oversold_mail.csv
perl bullishquery_535_best_new.pl $NOW $PREVDATE 7 >> bull/oversold_mail.csv 
perl bullishquery_535_best_new.pl $NOW $PREVDATE 8 >> bull/oversold_mail.csv
perl bullishquery_535_best_new.pl $NOW $PREVDATE 9 >> bull/oversold_mail.csv
perl bullishquery_535_best_new.pl $NOW $PREVDATE 10 >>bull/oversold_mail.csv
perl bullishquery_535_best_new.pl $NOW $PREVDATE 11 >>bull/oversold_mail.csv

