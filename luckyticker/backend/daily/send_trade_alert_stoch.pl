#!/usr/bin/perl -w
use MIME::Lite;
#my ($pid) = fork();
my ($a,$b,$c,$d,$m,$y) = (localtime)[0,1,2,3,4,5];
my $str = sprintf '%04d-%02d-%02d', $y+1900,$m+1,$d;
my $pid = $a.$b.$c;
use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
# $os_query = "select a.ticker_id,b.sma_3_3_stc_osci_14,b.price_date from tickermaster a, tickerprice b where a.ticker_id = b.ticker_id and b.price_date = '"+cur_date+"'   and sma_3_3_stc_osci_14 < 20 and sma_3_3_stc_osci_14 > 1 and close_price > 5 order by sma_3_3_stc_osci_14 asc"
#stoch overbought
# $ob_query = "select a.ticker_id,b.sma_3_3_stc_osci_14,b.price_date from tickermaster a, tickerprice b where a.ticker_id = b.ticker_id  and b.price_date = '"+cur_date+"'   and sma_3_3_stc_osci_14 > 80 and sma_3_3_stc_osci_14 < 99 and close_price > 5 order by sma_3_3_stc_osci_14 desc"

my  ($sql) = "select 'Buy',c.ticker,c.comp_name,d.sma_3_3_stc_osci_14,d.seq from tickermaster c,tickerrtq7 d,(select a.ticker_id,max(a.seq) maxseq from tickerrtq7 a where a.price_date = '$str' group by a.ticker_id) b where c.ticker_id = b.ticker_id  and c.tflag2 = 'Y' and d.seq = b.maxseq and d.ticker_id = b.ticker_id  and d.sma_3_3_stc_osci_14 < 20 and d.sma_3_3_stc_osci_14  >  1
union 
select 'Sell',c.ticker,c.comp_name,d.sma_3_3_stc_osci_14,d.seq from tickermaster c,tickerrtq7 d,(select a.ticker_id,max(a.seq) maxseq from tickerrtq7 a where a.price_date = '$str' group by a.ticker_id) b where c.ticker_id = b.ticker_id  and c.tflag2 = 'Y' and d.seq = b.maxseq and d.ticker_id = b.ticker_id  and d.sma_3_3_stc_osci_14 > 80 and d.sma_3_3_stc_osci_14 < 99";
#print $sql;
#
my ($msg, $subject, $Mail_msg);
$subject = 'daily trade alert stochastic - '.$str;
$Mail_msg = "<html><head></head><body>";
$Mail_msg .= "<h2>Tickerlick - Stochastic Trade Alert</h2><br><br>";
my $reccount =0;
   my $file = "/home/tthaliath/tickerlick/daily/tradealertstoch/tradealert-".$str."-".$pid."\.csv";
    #print "$file\n";
     #open(OUT,">$file");
     #print "$sql\n";
      $sth = $dbh->prepare($sql);
       #$sth2 = $dbh->prepare($ins);
       $sth->execute or die "SQL Error: $DBI::errstr\n";
        while (@row = $sth->fetchrow_array) {
         if ($reccount == 0)
         {
           open(OUT,">$file");
         }
         $Mail_msg .= "<a href='http://www.tickerlick.com/quote?q=$row[1]'>$row[0] - $row[1] - $row[2]</a><br>";
         print OUT "$row[0],$row[1],$row[2],$row[3]\n";
         #$sth2->execute($row[4],$row[0],$row[1]) or die "SQL Error: $DBI::errstr\n";
         $reccount++;
         }
         #print "$row[0],$row[1],$row[2]\n";
          if ( -e $file)
           {
            close (OUT);
            }
             $sth->finish;
              #$sth2->finish;
$Mail_msg .= "</body></html>";
#print "$Mail_msg\n";
if ($reccount > 0)
{
 my $query = "select usermail from userreport where report_code = 'INT' and subscription_flag  = 'Y'";
 $sth1 = $dbh->prepare($query);
 $sth1->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth1->fetchrow_array)
 {
    print "$row[0]\n";
    $msg = MIME::Lite->new(
    From    => 'info@tickerlick.com',
    To      => $row[0],
    Subject => $subject, 
    Data   => $Mail_msg
);
$msg->attr("content-type" => "text/html");
$msg->send;
}
$sth1->finish;
}
$dbh->disconnect;
