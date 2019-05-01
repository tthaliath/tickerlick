#!/usr/bin/perl

use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql ="select a.price_date, a.close_price, a.high_price_14,a.low_price_14, stc_osci_14, ema_3_stc_osci_14 from tickerprice a where a.ticker_id = 9;";
print "price_date,close_price,high_price_14,low_price_14, stc_osci_14, ema_3_stc_osci_14\n";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
 print "$row[0],$row[1],$row[2],$row[3],$row[4],$row[5],$row[6]\n";
} 
 $sth->finish;
 $dbh->disconnect; 
