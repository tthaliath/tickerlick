#!/usr/bin/perl
#open (F,"</home/tthaliath/tickerlick/daily/ustickermaster_20140506.csv");
#open (F,"</home/tthaliath/tickerlick/history/new1/ustickernew.csv");
#open (F,"</home/tthaliath/tickerlick/daily/ustickermaster_20141226.csv");
#open (F,"</home/tthaliath/eoddata/ticker_052716.csv");
#open (F,"</home/tthaliath/eoddata/newtickerid_20160819.csv");
open (F,"</home/tthaliath/eoddata/ticker_single_reload.csv");
#open (F,"</home/tthaliath/eoddata/ticker_052217.csv");
open (out,">/home/tthaliath/tickerlick/history/new1/tickout.log");
my ($ticker_id,$ticker,@rest,$count);
while (<F>)
{
chomp;
($ticker_id,$ticker,@rest) = split (/\,/,$_);
print "$ticker_id,$ticker\n";
#if ($ticker_id <= 13238){next;}
#++$count;
#next;
system("/home/tthaliath/tickerlick/history/new1/getustickerhistoryfull_1.pl $ticker_id $ticker");
system("/home/tthaliath/tickerlick/history/new1/getustickerhistorysummaryfull_2.pl $ticker_id");
system("/home/tthaliath/tickerlick/history/new1/loadprice_full_3.pl $ticker_id");
system("/home/tthaliath/tickerlick/history/new1/update_dma_history_4.pl $ticker_id");
system("/home/tthaliath/tickerlick/history/new1/update_loss_gain_full_5.pl $ticker_id");
system("/home/tthaliath/tickerlick/history/new1/update_avg_loss_gain_full_6.pl $ticker_id");
system("/home/tthaliath/tickerlick/history/new1/stoch_update_dma_full_7.pl $ticker_id");
system("/home/tthaliath/tickerlick/history/new1/update_ema_1226_daily_start_8.pl $ticker_id");
system("/home/tthaliath/tickerlick/history/new1/update_ema_1226_full_9.pl $ticker_id");
system("/home/tthaliath/tickerlick/history/new1/update_ema_macd_1226_start_10.pl $ticker_id");
system("/home/tthaliath/tickerlick/history/new1/update_ema_macd_1226_full_11.pl $ticker_id");
system("/home/tthaliath/tickerlick/history/new1/update_ema_535_start_12.pl $ticker_id");
system("/home/tthaliath/tickerlick/history/new1/update_ema_535_full_13.pl $ticker_id");
system("/home/tthaliath/tickerlick/history/new1/update_ema_macd_535_start_14.pl $ticker_id");
system("/home/tthaliath/tickerlick/history/new1/update_ema_macd_535_full_15.pl $ticker_id");
system("/home/tthaliath/tickerlick/history/new1/update_dma_history_4_single.pl $ticker_id");
system("/home/tthaliath/tickerlick/history/new1/rsistoch_update_full_16_single.pl $ticker_id");
#if ($count == 2 ){last;}
print out  "$ticker_id,$ticker\n";
#last;
}
close (F);
close (out);
exit 1;
