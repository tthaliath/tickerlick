#!/usr/bin/perl
use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
open (F,"</home/tthaliath/tickerlick/daily/ustickermaster_20150729.csv");
while (<F>)
{
 chomp;
 ($ticker_id,@rest) = split (/\,/,$_);
 $query = "update tickermaster set price_flag = 'Y' where ticker_id = $ticker_id";
 #print "$query\n";
 $dbh->do($query);
}
$dbh->disconnect;
close (F);
