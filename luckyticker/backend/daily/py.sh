#get today's date
NOW=$(date +"%Y-%m-%d")
export NOW='2014-06-19'

echo $NOW


python /home/tthaliath/tickerlick/daily/clearoldlist.py
python /home/tthaliath/tickerlick/daily/rsi_rep.py $NOW
python /home/tthaliath/tickerlick/daily/stoch_rep.py $NOW
