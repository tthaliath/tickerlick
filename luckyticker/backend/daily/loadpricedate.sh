#get today's date
#NOW=$(date +"%Y-%m-%d")
export NOW='2013-01-02'

echo $NOW
#run dma 
./update_dma_daily_date.pl $NOW
#run ema 1226
./update_ema_daily_date.pl $NOW
#run ema macd
./update_ema_macd_daily_history_date.pl $NOW
#run ema 935
./update_ema_macd_manual_date.pl $NOW

echo "DONE"

