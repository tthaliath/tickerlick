#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI; 
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
$sql = "select ticker_id,ticker from tickermaster where  tflag = 'Y' ";
$sth = $dbh->prepare($sql);
$sth->execute or die "SQL Error: $DBI::errstr\n";
while (@row = $sth->fetchrow_array) {
print "$row[0],$row[1]\n";
}

$sth>finish;
$dbh->disconnect;
