#get today's date
NOW=$(date +"%Y-%m-%d")
#export NOW='2015-12-11'

echo $NOW
#load  ratings
/home/tthaliath/python3/getdividend.py $NOW

