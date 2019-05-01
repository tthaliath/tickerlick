#!/usr/bin/perl
use DBI;
my (%tickhash) ={};
my $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
#open (F,"</home/tthaliath/tickerlick/daily/ustickermaster_20151127.csv");
$sql = "select ticker_id,ticker from tickermaster where price_flag = 'Y'";
my $sth = $dbh->prepare($sql);
$sth->execute();
while (@row = $sth->fetchrow_array) {
        $tickhash{$row[1]} = $row[0];
}
$sth->finish;
$dbh->disconnect;

open (IN,"</home/tthaliath/tickerlick/daily/pricehistnew.csv");
open (OUT,">/home/tthaliath/tickerlick/daily/pricehist.csv");
$dirname = "/home/tthaliath/tickerlick/daily/usticker";
$today = $ARGV[0];
$today =~ s/\-//g;
#Symbol,Date,Open,High,Low,Close,Volume
while (<IN>)
 {
 chomp;
 ($symbol,$date,$open,$high,$low,$close,$volume) = split (/\,/,$_);
 if ($symbol eq 'Symbol'){next;} 
 if ($tickhash{$symbol})
 {
   print OUT "$tickhash{$symbol},$date,$high,$low,$close\n";
 }
         
 }
closedir(DIR);
close (OUT);
#copy data file to data dir
$data_dir = "/home/tthaliath/tickerdata/history/price/daily/$today/pricehist.csv";
system ("cp /home/tthaliath/tickerlick/daily/pricehist.csv  $data_dir");

