#get today's date
NOW=$(date +"%Y-%m-%d")
#export NOW='2017-07-20'

echo $NOW
#download  ratings
/home/tthaliath/python3/getratings.py $NOW
#load ratings
/home/tthaliath/python3/loadratings.py $NOW  

