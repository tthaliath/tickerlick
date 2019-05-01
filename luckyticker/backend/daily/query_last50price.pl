#!/usr/bin/perl

use DBI;
my ($ticker_id);
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql = "select ticker_id from tickermaster where ticker = 'AAPL'";
  $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
  $ticker_id = $row[0];
}

 $sql ="select a.price_date, a.close_price, a.dma_10, a.dma_50, a.dma_200 from tickerprice a where a.ticker_id = $ticker_id ORDER BY a.price_date DESC LIMIT 0,50;";
print "price_date,close_price,dma_10,dma_50,dma_200\n";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
 print "$row[0],$row[1],$row[2],$row[3],$row[4]\n";
} 
 $sth->finish;
 $dbh->disconnect; 
