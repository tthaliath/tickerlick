#!/usr/bin/perl -w
use MIME::Lite;
my $day  = $ARGV[0];
#!/usr/bin/perl
#
use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql = "select a.ticker,a.comp_name,'Bullish' from tickermaster a, (select ticker_id, count(*) from report where report_flag in ('SS','RS','BBU') GROUP BY ticker_id having count(*) = 3) b where a.ticker_id = b.ticker_id union select a.ticker,a.comp_name,'Bearish' from tickermaster a, (select ticker_id, count(*) from report where report_flag in ('SB','RB','BBE') GROUP BY ticker_id having count(*) = 3) b where a.ticker_id = b.ticker_id";
  #print "50,dma_200,spydma200\n";
   my $file = "/home/tthaliath/tickerlick/daily/signal/signal-".$day."\.csv";
    print "$file\n";
     open(OUT,">$file");
      $sth = $dbh->prepare($sql);
       $sth->execute or die "SQL Error: $DBI::errstr\n";
        while (@row = $sth->fetchrow_array) {
         print OUT "$row[0],$row[1],$row[2]\n";
          }
            close (OUT);
             $sth->finish;
              $dbh->disconnect;
my $msg = MIME::Lite->new(
    From    => 'info@tickerlick.com',
    To      => 'tthaliath@gmail.com',
    Subject => 'daily security list',
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
