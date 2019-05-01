#!/usr/bin/perl -w
use MIME::Lite;
my ($d,$m,$y) = (localtime)[3,4,5];
my $str = sprintf '%04d-%02d-%02d', $y+1900,$m+1,$d;
use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql = "select a.ticker, comp_name from earnings_master a, tickermaster b where a.ticker_id = b.ticker_id and a.earnings_date = '$str' ";
   my $file = "/home/tthaliath/tickerlick/daily/earnings/earnings-".$str."\.csv";
    print "$file\n";
     open(OUT,">$file");
      $sth = $dbh->prepare($sql);
       $sth->execute or die "SQL Error: $DBI::errstr\n";
        while (@row = $sth->fetchrow_array) {
         print OUT "$row[0],$row[1]\n";
          }
            close (OUT);
             $sth->finish;
              $dbh->disconnect;
my $msg = MIME::Lite->new(
    From    => 'info@tickerlick.com',
    To      => 'tthaliath@gmail.com',
    Subject => 'daily earnings report',
    Type    => 'multipart/mixed',
);
my $Mail_msg = "$str\n\n";
$Mail_msg .= "Tickerlick - Earnings Today\n\n";
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
