#!/usr/bin/perl
use DBI;
my ($today) = $ARGV[0];
#print "today:$today\n";
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
my($query) = "select price_date from secpricert where ticker_id = 9 and price_date < '".$today."' order by price_date desc limit 1";
#print "$query\n";
$sth = $dbh->prepare($query);
$sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
   $price_date = $row[0];
}
$dbh->disconnect; 
open (F,">/home/tthaliath/tickerlick/daily/prevdatertq");
print F  "$price_date";
close (F);

