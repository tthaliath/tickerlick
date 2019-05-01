#!/usr/bin/perl

use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql ="select a.ticker_id,a.price_date, a.close_price, a.high_price,a.low_price from tickerprice a where a.ticker_id = 9;";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
 $day = $row[1];
 $day =~ s/\-//g;
 print "$row[0],$day,$row[3],$row[4],$row[2]\n";
} 
 $sth->finish;
 $dbh->disconnect; 
