#!/usr/bin/perl

use DBI;
$limit = 200;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql ="SELECT avg(close_price) AS avg_prc, max(price_date) as pdate FROM (SELECT close_price, price_date FROM tickerprice WHERE ticker_id = 1 ORDER BY price_date DESC LIMIT $limit) AS abc;";
 #$sql = "select * from tickerprice where ticker_id =1 order by  price_date desc limit 200";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
 print "$row[0]\t$row[1]\t$offset\n";
 $sql = "update tickerprice set dma_200 = $row[0] where ticker_id = 1 and price_date = '$row[1]'";
 print "$sql\n";
 $ret = $dbh->do($sql);
} 
 $sth->finish;
 $dbh->disconnect; 
