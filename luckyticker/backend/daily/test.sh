#generating reports
/home/tthaliath/tickerlick/daily/oversoldnew.sh
/home/tthaliath/tickerlick/daily/overboughtnew.sh
NOW=$(date +"%Y-%m-%d")
#sending report
/home/tthaliath/tickerlick/daily/mail.pl $NOW
echo "DONE"
