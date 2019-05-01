#!/usr/bin/perl -w
#my ($pid) = fork();
my $price_date = $ARGV[0];
my ($ord_id,$now,$dbh,@row,$sth,$sql,$tickerlist,%tickhash,$tick,$quote,$prev_date,$prev_prev_date);
sleep(15);
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
$prev_query ="select max(price_date) from tickerrtq6 where ticker_id = 9 and price_date < '$price_date' ";
$sth_date = $dbh->prepare($prev_query);
 $sth_date->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth_date->fetchrow_array) {
 $prev_date = $row[0];
 }
$sth_date->finish();
my ($a,$b,$c,$d,$m,$y) = (localtime)[0,1,2,3,4,5];
my $str = sprintf '%04d-%02d-%02d', $y+1900,$m+1,$d;
my $pid = $a.$b.$c;
use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
$sql = "select f.ticker, f.comp_name, e.close_price as prev_price, d.rtq as last_price,(((d.rtq - e.close_price)/d.rtq) * 100) as per from tickerrtq6 d, tickerprice e, tickermaster f,(select a.ticker_id, max(seq) seqmax from tickerrtq6 a, tickermaster b where a.ticker_id = b.ticker_id and b.tflag = 'Y' and a.price_date  = '$price_date' group by ticker_id) c where d.seq = c.seqmax and d.ticker_id  = e.ticker_id and e.price_date = '$prev_date' and d.ticker_id = f.ticker_id and abs (((d.rtq - e.close_price)/d.rtq) * 100) > 3 order by per asc";
#print $sql;
#
my ($msg, $subject, $Mail_msg);
$subject = 'SP500 UpDown daily trade alert - '.$str;
$Mail_msg = "<html><head><style>.redtext{color: red;}</style></head><body>";
$Mail_msg .= "<h2>Tickerlick - SP500 UpDown Trade Alert</h2><br><br>";
my $reccount =0;
   my $file = "/home/tthaliath/tickerlick/daily/sp500updown/sp500tradealert-".$str."-".$pid."\.csv";
    #print "$file\n";
     #open(OUT,">$file");
     #print "$sql\n";
      $sth = $dbh->prepare($sql);
       $sth->execute or die "SQL Error: $DBI::errstr\n";
        while (@row = $sth->fetchrow_array) {
         if ($reccount == 0)
         {
           open(OUT,">$file");
         }
         $rounded = sprintf "%.2f", $row[4]; 
         if ($rounded < 0){
         $Mail_msg .= "<a href='http://www.tickerlick.com/quote?q=$row[0]'>$row[0] - $row[1]: <b class=redtext>$rounded</b></a><br>";
          }
          else
         {
           $Mail_msg .= "<a href='http://www.tickerlick.com/quote?q=$row[0]'>$row[0] - $row[1]: <b>$rounded</b></a><br>";
}
         print OUT "$row[0],$row[1],$row[2],$row[3],$rounded\n";
         $reccount++;
         }
         #print "$row[0],$row[1],$row[2]\n";
          if ( -e $file)
           {
            close (OUT);
            }
             $sth->finish;
$Mail_msg .= "</body></html>";
open (OUT,">out.html");
#print OUT "$pid\n";
print OUT "$Mail_msg\n";
close (OUT);
system("cp out.html /home/tickerlick/www/html/sp500updown.html"); 
$dbh->disconnect;
