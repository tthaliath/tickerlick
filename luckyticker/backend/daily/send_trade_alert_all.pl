#!/usr/bin/perl -w
use MIME::Lite;
my ($d,$m,$y) = (localtime)[3,4,5];
my $str = sprintf '%04d-%02d-%02d', $y+1900,$m+1,$d;
use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
my  $sql = "select c.ticker,c.comp_name,d.rsi_14,d.seq from tickermaster c,tickerrtq1 d,(select a.ticker_id,max(a.seq) maxseq from tickerrtq1 a where a.price_date = '$str' group by a.ticker_id) b where c.ticker_id = b.ticker_id  and d.seq = b.maxseq and d.ticker_id = b.ticker_id  and d.rsi_14 < 30 and d.rsi_14 != 0 order by d.rsi_14 asc;";
#print "$sql\n";
#
   my $file = "/home/tthaliath/tickerlick/daily/tradealert/tradealert-".$str."\.csv";
    print "$file\n";
     open(OUT,">$file");
      $sth = $dbh->prepare($sql);
       $sth->execute or die "SQL Error: $DBI::errstr\n";
        while (@row = $sth->fetchrow_array) {
         print OUT "$row[0],$row[1],$row[2]\n";
         print "$row[0],$row[1],$row[2]\n";
          }
            close (OUT);
             $sth->finish;
              $dbh->disconnect;
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
