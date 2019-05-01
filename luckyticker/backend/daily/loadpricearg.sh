#get today's date
#NOW=$(date +"%Y-%m-%d")
#export NOW='2013-01-02'
echo $1
#echo $NOW
#run dma 
#./update_dma_daily_date.pl $1
#run ema 1226
#./update_ema_daily_date.pl $1 
#run ema macd
./update_ema_macd_daily_history_date.pl $1
#run ema 935
./update_ema_macd_manual_date.pl $1 

echo "DONE"

