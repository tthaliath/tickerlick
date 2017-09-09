#!/usr/bin/perl -w
use MIME::Lite;
use DBI;
use strict;
use warnings;
my (@row,$sth1);
my ($PASSWORD) = $ENV{DBPASSWORD};
my($today) = $ARGV[0]; 
my $dbh = DBI->connect('dbi:mysql:tickmaster','root',$PASSWORD)
 or die "Connection Error: $DBI::errstr\n";
my $sql = "select c.ticker, c.comp_name,a.price_date,a.close_price,(ema_diff - ema_macd_9) as signalstrength, (ema_diff_5_35 - ema_macd_5) as signalstrength2,b.rsi_14 as rsi, sma_3_3_stc_osci_14,(4*dma_20_sd/dma_20) as bolli  from tickerprice a,  tickerpricersi b, tickermaster c  where c.ticker_id = a.ticker_id and a.ticker_id = b.ticker_id and a.price_date = b.price_date and dma_20 is not null and dma_20_sd is not null and a.ticker_id <= 14000 and a.price_date = '$today' and (4*dma_20_sd/dma_20) between 0.1 and 0.25 and b.rsi_14 < 40 and sma_3_3_stc_osci_14 < 40 and (a.close_price - (dma_20 - (2 * dma_20_sd))) <= 0";

my $Mail_msg = "<html><head></head><body>";
$Mail_msg .= "<h2>Tickerlick - Bollinger Buy Stocks - $today</h2>";
  #print "$sql\n";
   my $file = "/home/tthaliath/tickerlick/daily/signal/signal_bolli_buy_".$today."\.csv";
   my $flag = 0;
    #print "$file\n";
     open(OUT,">$file");
      print OUT "ticker,name,price_date, close_price, macd long,macd short,RSI, Stoch,bolli\n";
      my $sth = $dbh->prepare($sql);
       $sth->execute or die "SQL Error: $DBI::errstr\n";
        while (@row = $sth->fetchrow_array) {
         print OUT "$row[0],$row[1],$row[2],$row[3],$row[4],$row[5],$row[6],$row[7],$row[8]\n";
         $Mail_msg .= "<a href='http://www.tickerlick.com/cgi-bin/gettickermain2json.cgi?q=$row[0]'>$row[0] - $row[1]</a><br>";
          $flag = 1;
          }
          $Mail_msg .= "</body></html>";
            close (OUT);
             $sth->finish;
if ($flag)
{
my ($msg,$recepient,$subject);
$subject = "Tickerlick - Bollinger Buy Stocks as of ".$today;
my $query = "select usermail from userreport where report_code = 'OSD' and subscription_flag  = 'Y'";
 $sth1 = $dbh->prepare($query);
 $sth1->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth1->fetchrow_array) 
 {
    $recepient = $row[0]; 
    #print "$today\n";
    
    $msg = MIME::Lite->new(
    From    => 'info@tickerlick.com',
    To      => $recepient,
    Subject => $subject,
    Data     => $Mail_msg 
    );
   $msg->attr("content-type" => "text/html");
   $msg->send;
  }
}
$sth1->finish;
$dbh->disconnect;
