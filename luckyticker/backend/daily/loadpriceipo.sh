#get today's date
NOW=$(date +"%Y-%m-%d")
#export NOW='2015-07-20'

echo $NOW
rm /home/tthaliath/tickerlick/daily/usticker/ipo/*.*
#download price
/home/tthaliath/tickerlick/daily/getustickerhistory_ipo.pl $NOW
#create data file
/home/tthaliath/tickerlick/daily/getustickerhistorysummary_ipo.pl $NOW
#load data into database
/home/tthaliath/tickerlick/daily/loadprice_daily.pl $NOW
#run dma 
/home/tthaliath/tickerlick/daily/update_dma_daily.pl
#run ema 1226
/home/tthaliath/tickerlick/daily/update_ema_daily.pl $NOW
#run ema macd
/home/tthaliath/tickerlick/daily/update_ema_macd_daily_history.pl
#run ema 935
/home/tthaliath/tickerlick/daily/update_ema_macd_manual.pl $NOW

#run rsi
echo "RSI"
/home/tthaliath/tickerlick/daily/4_update_loss_gain_daily.pl $NOW
/home/tthaliath/tickerlick/daily/5_update_avg_loss_gain_daily.pl $NOW
echo "Stochastic"
/home/tthaliath/tickerlick/daily/5_stoch_update_dma_daily.pl


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
echo "DONE"

