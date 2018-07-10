#!/usr/bin/perl -w
use MIME::Lite;
use strict;
use warnings;
#my ($pid) = fork();
my ($a,$b,$c,$d,$m,$y) = (localtime)[0,1,2,3,4,5];
my $str = sprintf '%04d-%02d-%02d', $y+1900,$m+1,$d;
my $pid = $a.$b.$c;
my ($PASSWORD) = $ENV{DBPASSWORD};
use DBI;
my $dbh = DBI->connect('dbi:mysql:tickmaster','root',$PASSWORD)
 or die "Connection Error: $DBI::errstr\n";
my ($sql) = "select 'Buy',c.ticker,c.comp_name,d.rsi_14,d.seq from tickermaster c,tickerrtq7 d,(select a.ticker_id,max(a.seq) maxseq from tickerrtq7 a where a.price_date = '$str' group by a.ticker_id) b where c.ticker_id = b.ticker_id  and c.tflag2 = 'Y' and d.seq = b.maxseq and d.ticker_id = b.ticker_id  and d.rsi_14 < 25  and d.rsi_14 != 0
union
select 'Sell', c.ticker,c.comp_name,d.rsi_14,d.seq from tickermaster c,tickerrtq7 d,(select a.ticker_id,max(a.seq) maxseq from tickerrtq7 a where a.price_date = '$str' group by a.ticker_id) b where c.ticker_id = b.ticker_id and c.tflag2 = 'Y'  and d.seq = b.maxseq and d.ticker_id = b.ticker_id  and d.rsi_14 > 75 and d.rsi_14 != 0 order by rsi_14 asc";
my $ins = 'insert into trade_signal_seq_back (seq,signal1,ticker,quotetime) values(?,?,?,now())';
#print $sql;
#
my ($msg,$sth1, $subject, $Mail_msg,$sth,$sth2,@row);
$subject = 'daily trade alert RSI - '.$str;
$Mail_msg = "<html><head></head><body>";
$Mail_msg .= "<h2>Tickerlick - Trade Alert - RSI</h2><br><br>";
my $reccount =0;
   my $file = "/home/tthaliath/tickerlick/daily/tradealert/tradealert-".$str."-".$pid."\.csv";
    #print "$file\n";
     #open(OUT,">$file");
     #print "$sql\n";
      $sth = $dbh->prepare($sql);
       $sth2 = $dbh->prepare($ins);
       $sth->execute or die "SQL Error: $DBI::errstr\n";
        while (@row = $sth->fetchrow_array) {
         if ($reccount == 0)
         {
           open(OUT,">$file");
         }
         $Mail_msg .= "<a href='http://www.tickerlick.com/cgi-bin/gettickermain2json.cgi?q=$row[1]'>$row[0] - $row[1] - $row[2]</a><br>";
         print OUT "$row[0],$row[1],$row[2],$row[3]\n";
         $sth2->execute($row[4],$row[0],$row[1]) or die "SQL Error: $DBI::errstr\n";
         $reccount++;
         }
         #print "$row[0],$row[1],$row[2]\n";
          if ( -e $file)
           {
            close (OUT);
            }
             $sth->finish;
              $sth2->finish;
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
