#!/usr/bin/perl -w
use MIME::Lite;
my $ticker  = $ARGV[0];
#!/usr/bin/perl
#
use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
$sql = "select * from (select 'OS' as flag,ticker, a.price_date as pdate, a.close_price,rsi_14,sma_3_3_stc_osci_14 as stoch,(ema_diff - ema_macd_9) as macd12269, (ema_diff_5_35 - ema_macd_5) as macd535, round(((dma_20 + (2 * dma_20_sd)) - a.close_price ),4) as high,round((a.close_price - (dma_20 - (2 * dma_20_sd))),4) as low from tickerprice a, tickerpricersi b, tickermaster c  where c.ticker_id = a.ticker_id and a.ticker_id = b.ticker_id and a.price_date = b.price_date and rsi_14 < 40  and (ema_diff_5_35 - ema_macd_5) < 0 and (a.close_price - (dma_20 - (2 * dma_20_sd))) < 3  and ticker = '$ticker' and a.price_date >= '2013-01-01'  union select 'OB' as flag,ticker, a.price_date as pdate, a.close_price,rsi_14,sma_3_3_stc_osci_14 as stoch,(ema_diff - ema_macd_9) as macd12269, (ema_diff_5_35 - ema_macd_5) as macd535, round(((dma_20 + (2 * dma_20_sd)) - a.close_price ),4) as high,round((a.close_price - (dma_20 - (2 * dma_20_sd))),4) as low from tickerprice a, tickerpricersi b, tickermaster c  where c.ticker_id = a.ticker_id and a.ticker_id = b.ticker_id and ticker = '$ticker' and a.price_date = b.price_date and a.price_date >= '2013-01-01' and rsi_14 > 70 and ((dma_20 + (2 * dma_20_sd)) - a.close_price ) < 10 and sma_3_3_stc_osci_14 > 60 and (ema_diff - ema_macd_9) is not null and (ema_diff_5_35 - ema_macd_5) is not null) ggg order by pdate asc";
  #print "50,dma_200,spydma200\n";
      #print OUT "price_date, close_price, signalstrength,sma_3_3_stc_osci_14,rsi_14, dma_20_top, dma_20_bottom, dma_20_sd, bollidif\n";
      $sth = $dbh->prepare($sql);
       $sth->execute or die "SQL Error: $DBI::errstr\n";
        while (@row = $sth->fetchrow_array) {
         print  "$row[0],$row[1],$row[2],$row[3],$row[4],$row[5],$row[6],$row[7],$row[8]\n";
          }
             $sth->finish;
              $dbh->disconnect;

