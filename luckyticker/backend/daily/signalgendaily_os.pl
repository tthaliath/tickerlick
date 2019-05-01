#!/usr/bin/perl -w
use MIME::Lite;
use DBI;
my($today) = $ARGV[0]; 
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 #$sql = "select c.ticker,c.comp_name, c.sector,a.price_date, a.close_price, (ema_diff_5_35 - ema_macd_5) as MACD,sma_3_3_stc_osci_14 as Stochastic,b.rsi_14 as RSI, dma_20_sd, (((dma_20 + (2 * dma_20_sd))) - ((dma_20 -  (2 * dma_20_sd)))) 'BOLLINGER' from tickerprice a, tickerpricersi b, tickermaster c  where c.ticker_id = a.ticker_id and a.ticker_id = b.ticker_id and a.price_date = b.price_date and (ema_diff_5_35 - ema_macd_5) < 0 and b.rsi_14 < 30 and sma_3_3_stc_osci_14 < 30 and a.price_date = '$today' and b.price_date = '$today' and c.tflag = 'Y'";
$sql = "select  c.ticker,c.comp_name, c.sector,a.price_date, a.close_price, (ema_diff_5_35 - ema_macd_5) as MACD,sma_3_3_stc_osci_14 as Stochastic,b.rsi_14 as RSI, dma_20_sd, (((dma_20 + (2 * dma_20_sd))) - ((dma_20 -  (2 * dma_20_sd)))) 'BOLLINGER' from tickerprice a, tickerpricersi b, tickermaster c  where c.ticker_id = a.ticker_id and a.ticker_id = b.ticker_id and a.price_date = b.price_date and a.price_date = '$today' and rsi_14 < 30  and (a.close_price - (dma_20 - (2 * dma_20_sd))) < 0" ;

  #print "$sql\n";
   my $file = "/home/tthaliath/tickerlick/daily/signal/signal_os_".$today."\.csv";
   my $flag = 0;
    #print "$file\n";
     open(OUT,">$file");
      print OUT "ticker,name,sector,price_date, close_price, macd,stoch,RSI, dma_20_sd, bollinger\n";
      $sth = $dbh->prepare($sql);
       $sth->execute or die "SQL Error: $DBI::errstr\n";
        while (@row = $sth->fetchrow_array) {
         if (!$row[5]){$row[5] = 0;}
         print OUT "$row[0],$row[1],$row[2],$row[3],$row[4],$row[5],$row[6],$row[7],$row[8],$row[9]\n";
          $flag = 1;
          }
            close (OUT);
             $sth->finish;
              $dbh->disconnect;
if ($flag)
{
my $msg = MIME::Lite->new(
    From    => 'info@tickerlick.com',
    To      => 'tthaliath@gmail.com',
    Subject => 'signal history - OS',
    Type    => 'multipart/mixed',
    Disposition     =>'attach',
);
my $Mail_msg = "Tickerlick - Signal-oversold-$today\n\n";
open (F,"<$file");
undef $/;
$Mail_msg .= <F>;
close (F);
$/ = 1;
close (F);
### Add the text message part
 $msg->attach (
  Type => 'TEXT',
   Data => $Mail_msg
   ) or die "Error adding the text message part: $!\n";

$msg->send;
}
