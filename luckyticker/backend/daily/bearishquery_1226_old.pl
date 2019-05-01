#!/usr/bin/perl

use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql ="select b.ticker_id,b.ticker,b.comp_name,b.sector,b.industry from tickermaster b,tickerprice a where a.ema_diff < a.ema_macd_9 and a.price_date = \"2012-12-21\" and a.ticker_id = b.ticker_id and exists (select 1 from tickerprice p where p.ticker_id = a.ticker_id and p.price_date = \"2012-12-20\" and p.ema_diff > p.ema_macd_9) order by b.ticker asc;";
#print "50,dma_200,spydma200\n";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
 print "$row[0],$row[1],$row[2],$row[3],$row[4]\n";
} 
 $sth->finish;
 $dbh->disconnect; 
