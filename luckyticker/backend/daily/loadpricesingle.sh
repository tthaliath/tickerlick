#get today's date
NOW=$(date +"%Y-%m-%d")
export NOW='2015-12-24'
export TICKER='NKE';
echo $NOW
rm /home/tthaliath/tickerlick/daily/usticker/*.*
#download price
/home/tthaliath/tickerlick/daily/getustickerhistorysingle.pl $NOW $TICKER
#create data file
/home/tthaliath/tickerlick/daily/getustickerhistorysummary.pl $NOW
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

echo "RSIStochasic"
/home/tthaliath/tickerlick/history/new1/rsistoch_update_daily_16.pl
#clear old reports
python /home/tthaliath/tickerlick/daily/clearoldlist.py
#generating reports
/home/tthaliath/tickerlick/daily/macdrep.sh
/home/tthaliath/tickerlick/daily/oversoldweb.sh
/home/tthaliath/tickerlick/daily/overboughtweb.sh
python /home/tthaliath/tickerlick/daily/rsi_rep.py $NOW
python /home/tthaliath/tickerlick/daily/stoch_rep.py $NOW
python /home/tthaliath/tickerlick/daily/bolli_rep.py $NOW
#sending report - RSI plus stochastic
/home/tthaliath/tickerlick/daily/sandp200gen.pl $NOW
#sending report - RSI ONLY
/home/tthaliath/tickerlick/daily/sandp200gen_rsi.pl $NOW
/home/tthaliath/tickerlick/daily/signalgendaily_os.pl $NOW
/home/tthaliath/tickerlick/daily/signalgendaily_ob.pl $NOW
echo "DONE"

