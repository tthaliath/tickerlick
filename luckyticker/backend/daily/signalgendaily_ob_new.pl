#!/usr/bin/perl -w
use MIME::Lite;
use DBI;
my($today) = $ARGV[0]; 
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
$sql = "SELECT distinct a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b, (select ticker_id,count(*) from report c where c.report_flag in ('BBE','MBE','OB','RB','SB') group by c.ticker_id having count(*) > 2) c where b.ticker_id = a.ticker_id and b.ticker_id = c.ticker_id order by sector";
my $Mail_msg = "<html><head></head><body>";
$Mail_msg .= "<h2>Tickerlick - Overbought Stocks - $today</h2>";
  #print "$sql\n";
   my $file = "/home/tthaliath/tickerlick/daily/signal/signal_xob_".$today."\.csv";
   my $flag = 0;
    #print "$file\n";
     open(OUT,">$file");
      print OUT "ticker,name,sector,price_date, close_price, macd,stoch,RSI, dma_20_sd, bollinger\n";
      $sth = $dbh->prepare($sql);
       $sth->execute or die "SQL Error: $DBI::errstr\n";
        while (@row = $sth->fetchrow_array) {
         print OUT "$row[0],$row[1],$row[2],$row[3]\n";
         $Mail_msg .= "<a href='http://www.luckyticker.com/quote?q=$row[0]'>$row[0] - $row[1]</a><br>";
          $flag = 1;
          }
          $Mail_msg .= "</body></html>";
            close (OUT);
             $sth->finish;
if ($flag)
{
my ($msg,$recepient,$subject);
$subject = "Tickerlick - Overbought Stocks as of ".$today;
 my $query = "select usermail from userreport where report_code = 'OSD' and subscription_flag  = 'Y'";
 $sth1 = $dbh->prepare($query);
 $sth1->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth1->fetchrow_array) 
 {
    $recepient = $row[0]; 
    print "$recepient\n";
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
