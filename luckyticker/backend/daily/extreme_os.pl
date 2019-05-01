#!/usr/bin/perl -w
use MIME::Lite;
use DBI;
my($today) = $ARGV[0]; 
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 #$sql = "select c.ticker,c.comp_name, c.sector,a.price_date, a.close_price, (ema_diff_5_35 - ema_macd_5) as MACD,sma_3_3_stc_osci_14 as Stochastic,b.rsi_14 as RSI, dma_20_sd, (((dma_20 + (2 * dma_20_sd))) - ((dma_20 -  (2 * dma_20_sd)))) 'BOLLINGER' from tickerprice a, tickerpricersi b, tickermaster c  where c.ticker_id = a.ticker_id and a.ticker_id = b.ticker_id and a.price_date = b.price_date and (ema_diff_5_35 - ema_macd_5) < 0 and b.rsi_14 < 30 and sma_3_3_stc_osci_14 < 30 and a.price_date = '$today' and b.price_date = '$today' and c.tflag = 'Y'";
$sql = "select  a.ticker_id,a.close_price from tickerprice a, tickerpricersi b, tickermaster c  where c.ticker_id = a.ticker_id and a.ticker_id = b.ticker_id and a.price_date = b.price_date and a.price_date = '$today' and rsi_14 < 30  and (a.close_price - (dma_20 - (2 * dma_20_sd))) < 0 and sma_3_3_stc_osci_14 < 50 and (ema_diff - ema_macd_9) is not null and (ema_diff_5_35 - ema_macd_5) is not null" ;

  #print "$sql\n";
      $sth = $dbh->prepare($sql);
       $sth->execute or die "SQL Error: $DBI::errstr\n";
        while (@row = $sth->fetchrow_array) {
            $ins_sql = "insert into reporthistory (ticker_id,report_flag,report_date,close_price) values ($row[0],'xos','$today',$row[1])";
             $dbh->do($ins_sql);
          }
             $sth->finish;
              $dbh->disconnect;
