#!/usr/bin/perl

use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql ="select a.price_date, a.close_price, b.close_price as spyclode,a.dma_10, b.dma_10 as spydma10,a.dma_50, b.dma_50 as spydma50,a.dma_200, b.dma_200 as spydma200 from tickerprice a, v_spydma b where a.ticker_id = 1 and a.dma_10 is not null and a.price_date = b.price_date order by a.price_date desc;";
print "price_date,close_price,spy_close,dma_10,spydma10,dma_50,spydma50,dma_200,spydma200\n";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
 print "$row[0],$row[1],$row[2],$row[3],$row[4],$row[5],$row[6],$row[7],$row[8]\n";
} 
 $sth->finish;
 $dbh->disconnect; 
