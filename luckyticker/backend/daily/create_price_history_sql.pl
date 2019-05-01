#!/usr/bin/perl
use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";

open (F,"/home/tthaliath/tickerdata/history/price/daily/pricehisthl.csv");
while (<F>)
{
  chomp;
  ($tickerid,$pdate,$high,$low,$close) = split (/\,/,$_);
 $sql = "update  tickerprice set high_price = $high, low_price = $low where ticker_id = $tickerid and price_date = '$pdate'";
 print "$sql\n";
 $ret = $dbh->do($sql);
 last; 
}
 close (F);
$dbh->disconnect;
1;
