#!/usr/bin/perl
use strict;
use warnings;
open (F,"</home/tthaliath/eoddata/ticker_single_reload.csv");
#open (F,"</home/tthaliath/eoddata/ticker_052217.csv");
open (W,">/home/tthaliath/tickerlick/history/new1/tickout.log");
my ($ticker_id,$ticker,@rest,$count);
while (<F>)
{
chomp;
($ticker_id,$ticker,@rest) = split (/\,/,$_);
print "$ticker_id,$ticker\n";
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
print W  "$ticker_id,$ticker\n";
}
close (F);
close (W);
exit 1;
