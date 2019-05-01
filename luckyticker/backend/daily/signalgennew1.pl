#!/usr/bin/perl -w
use MIME::Lite;
my $ticker  = $ARGV[0];
#!/usr/bin/perl
#
use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql = "select a.price_date, a.close_price, (ema_diff_5_35 - ema_macd_5) as signalstrength2,sma_3_3_stc_osci_14,b.rsi_14, dma_20_sd, (((dma_20 + (2 * dma_20_sd))) - ((dma_20 -  (2 * dma_20_sd)))) 'bollidiff' from tickerprice a, tickerpricersi b, tickermaster c  where c.ticker = '$ticker' and c.ticker_id = a.ticker_id and a.ticker_id = b.ticker_id and a.price_date = b.price_date ORDER BY a.price_date DESC LIMIT 0,250";
  #print "50,dma_200,spydma200\n";
   my $file = "/home/tthaliath/tickerlick/daily/signal/signal-".$ticker."\.csv";
    print "$file\n";
     open(OUT,">$file");
      print OUT "$ticker\n";
      print OUT "price_date, close_price, macd,stoch,RSI, dma_20_sd, bollinger\n";

      #print OUT "price_date, close_price, signalstrength,sma_3_3_stc_osci_14,rsi_14, dma_20_top, dma_20_bottom, dma_20_sd, bollidif\n";
      $sth = $dbh->prepare($sql);
       $sth->execute or die "SQL Error: $DBI::errstr\n";
        while (@row = $sth->fetchrow_array) {
         print OUT "$row[0],$row[1],$row[2],$row[3],$row[4],$row[5],$row[6]\n";
          }
            close (OUT);
             $sth->finish;
              $dbh->disconnect;
