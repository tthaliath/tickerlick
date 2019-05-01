#!/usr/bin/perl
use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
$sth = $dbh->prepare("select price_date from tickerprice where ticker_id = 9 order by price_date desc limit 1,1");
$sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
   $price_date = $row[0];
}
$dbh->disconnect; 
open (F,">/home/tthaliath/tickerlick/daily/prevdate1");
print F  "$price_date";
close (F);

