#!/usr/bin/perl

use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql ='select count(*), ticker_id from tickerprice where ticker_id in  (select ticker_id from tickerprice where ema_26 is null and price_date = "2012-10-25") group by ticker_id;';
#print "50,dma_200,spydma200\n";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
 print "$row[0],$row[1]\n";
} 
 $sth->finish;
 $dbh->disconnect; 
