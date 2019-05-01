#!/usr/bin/perl -w
use MIME::Lite;
#my ($pid) = fork();
my ($a,$b,$c,$d,$m,$y) = (localtime)[0,1,2,3,4,5];
my $str = sprintf '%04d-%02d-%02d', $y+1900,$m+1,$d;
my $pid = $a.$b.$c;
use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
my  ($sql) = "select 'Buy',c.ticker,c.comp_name,d.rsi_14,d.seq from tickermaster c,tickerrtq4 d,(select a.ticker_id,max(a.seq) maxseq from tickerrtq4 a where a.price_date = '$str' group by a.ticker_id) b where c.ticker_id = b.ticker_id  and c.tflag = 'Y' and d.seq = b.maxseq and d.ticker_id = b.ticker_id  and d.rsi_14 < 30 and d.rsi_14 != 0 and c.ticker in (select distinct a1.ticker from tickermaster a1, (select ticker_id, count(*) from report where report_flag in ('SS','RS','BBU','MBU','OS') GROUP BY ticker_id having count(*) > 0) b1 where a1.ticker_id = b1.ticker_id and a1.tflag = 'Y' )
union 
select 'Sell', c.ticker,c.comp_name,d.rsi_14,d.seq from tickermaster c,tickerrtq4 d,(select a.ticker_id,max(a.seq) maxseq from tickerrtq4 a where a.price_date = '$str' group by a.ticker_id) b where c.ticker_id = b.ticker_id and c.tflag = 'Y'  and d.seq = b.maxseq and d.ticker_id = b.ticker_id  and d.rsi_14 >  70 and d.rsi_14 != 0 and c.ticker in (select distinct  a1.ticker from tickermaster a1, (select ticker_id, count(*) from report where report_flag in ('SB','RB','BBE','MBE','OB') GROUP BY ticker_id having count(*) > 0 ) b1 where a1.ticker_id = b1.ticker_id and a1.tflag = 'Y')
union
select 'Buy',c.ticker,c.comp_name,d.rsi_14,d.seq from tickermaster c,tickerrtq4 d,(select a.ticker_id,max(a.seq) maxseq from tickerrtq4 a where a.price_date = '$str' and a.ticker_id = 10909  group by a.ticker_id) b where c.ticker_id = b.ticker_id  and c.tflag = 'Y' and d.seq = b.maxseq and d.ticker_id = b.ticker_id  and d.rsi_14 < 30 and d.rsi_14 != 0
union
select 'Sell', c.ticker,c.comp_name,d.rsi_14,d.seq from tickermaster c,tickerrtq4 d,(select a.ticker_id,max(a.seq) maxseq from tickerrtq4 a where a.price_date = '$str' and a.ticker_id = 10909 group by a.ticker_id) b where c.ticker_id = b.ticker_id and c.tflag = 'Y'  and d.seq = b.maxseq and d.ticker_id = b.ticker_id  and d.rsi_14 >  70 and d.rsi_14 != 0 order by rsi_14 asc";


print "$sql\n";
#
my $reccount =0;
   my $file = "/home/tthaliath/tickerlick/daily/tradealert/tradealert-".$str."-".$pid."\.csv";
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
         print OUT "$row[0],$row[1],$row[2],$row[3]\n";
         $reccount++;
         }
         #print "$row[0],$row[1],$row[2]\n";
          if ( -e $file)
           {
            close (OUT);
            }
             $sth->finish;
              $dbh->disconnect;
if ($reccount > 0)
{
my $msg = MIME::Lite->new(
    From    => 'info@tickerlick.com',
    To      => 'tthaliath@gmail.com',
    Subject => 'daily trade alert', 
    Type    => 'multipart/mixed',
);
my $Mail_msg = "$str\n\n";
$Mail_msg .= "Tickerlick - Trade Alert\n\n";
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
