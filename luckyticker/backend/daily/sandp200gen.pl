#!/usr/bin/perl -w
use DBI;
use MIME::Lite;
my $day  = $ARGV[0];
my $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
# $sql = "select distinct a.ticker,a.comp_name,'Bullish' from tickermaster a, (select ticker_id, count(*) from report where report_flag in ('SS','RS','BBU','MBU','OS') GROUP BY ticker_id having count(*) > 1) b where a.ticker_id = b.ticker_id and a.tflag = 'Y' union select distinct  a.ticker,a.comp_name,'Bearish' from tickermaster a, (select ticker_id, count(*) from report where report_flag in ('SB','RB','BBE','MBE','OB') GROUP BY ticker_id having count(*) > 1 ) b where a.ticker_id = b.ticker_id and a.tflag = 'Y' ";
$sql = "select 'OS', c.ticker,c.comp_name, c.sector,a.price_date, a.close_price, (ema_diff_5_35 - ema_macd_5) as MACD,sma_3_3_stc_osci_14 as Stochastic,b.rsi_14 as RSI, dma_20_sd, (((dma_20 + (2 * dma_20_sd))) - ((dma_20 -  (2 * dma_20_sd)))) 'BOLLINGER', b.rsistoch_14 from tickerprice a, tickerpricersi b, tickermaster c  where a.price_date = '$day' and c.ticker_id = a.ticker_id and a.ticker_id = b.ticker_id and a.price_date = b.price_date  and (a.close_price - (dma_20 - (2 * dma_20_sd))) < 0 and rsistoch_14 < 0.20 and c.tflag = 'Y' union  select  'OB', c.ticker,c.comp_name, c.sector,a.price_date, a.close_price, (ema_diff_5_35 - ema_macd_5) as MACD,sma_3_3_stc_osci_14 as Stochastic,b.rsi_14 as RSI, dma_20_sd, (((dma_20 + (2 * dma_20_sd))) - ((dma_20 -  (2 * dma_20_sd)))) 'BOLLINGER', b.rsistoch_14 from tickerprice a, tickerpricersi b, tickermaster c  where a.price_date = '$day' and c.ticker_id = a.ticker_id and a.ticker_id = b.ticker_id and a.price_date = b.price_date  and ((dma_20 + (2 * dma_20_sd)) - a.close_price ) < 0 and rsistoch_14 > 0.80 and c.tflag =  'Y'";
 # print "$sql\n";
 my ($flag) = 0;
   my $file = "/home/tthaliath/tickerlick/daily/signal/signal-".$day."\.csv";
    print "$file\n";
     open(OUT,">$file");
      $sth = $dbh->prepare($sql);
       $sth->execute or die "SQL Error: $DBI::errstr\n";
        while (@row = $sth->fetchrow_array) {
         print OUT "$row[0],$row[1],$row[2],$row[5],$row[8]\n";
         #print "$row[0],$row[1],$row[2]\n";
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
    Subject => 'daily security list RSI - Stochastic',
    Type    => 'multipart/mixed',
);
my $Mail_msg = "$day\n\n";
$Mail_msg .= "Tickerlick - Signal\n\n";
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
