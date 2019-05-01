#get today's date
NOW=$(date +"%Y-%m-%d")
export NOW='2015-10-12'

echo $NOW
#clear old reports
python /home/tthaliath/tickerlick/daily/clearoldlist.py
#generating reports
/home/tthaliath/tickerlick/daily/macdrep.sh
/home/tthaliath/tickerlick/daily/oversoldweb.sh
/home/tthaliath/tickerlick/daily/overboughtweb.sh
python /home/tthaliath/tickerlick/daily/rsi_rep.py $NOW
python /home/tthaliath/tickerlick/daily/stoch_rep.py $NOW
python /home/tthaliath/tickerlick/daily/bolli_rep.py $NOW
#sending report
/home/tthaliath/tickerlick/daily/sandp200gen.pl $NOW
/home/tthaliath/tickerlick/daily/signalgendaily_os.pl $NOW
/home/tthaliath/tickerlick/daily/signalgendaily_ob.pl $NOW
echo "DONE"
