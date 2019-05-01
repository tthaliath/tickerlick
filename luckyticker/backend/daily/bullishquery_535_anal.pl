#!/usr/bin/perl

use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql ="select b1.ticker_id,b1.ticker,b1.comp_name,b1.sector,b1.industry from tickermaster b1,tickerprice a1 where a1.ema_diff_5_35 > a1.ema_macd_5 and a1.price_date = \"2012-12-03\" and a1.ticker_id = b1.ticker_id and exists (select 1 from tickerprice p1 where p1.ticker_id = a1.ticker_id and p1.price_date = \"2012-11-30\" and a1.close_price > p1.close_price) and exists (select 1 from tickerprice a where a.ema_diff_5_35 > a.ema_macd_5 and a.price_date = \"2012-11-30\" and a.ticker_id = a1.ticker_id and exists (select 1 from tickerprice p where p.ticker_id = a.ticker_id and p.price_date = \"2012-11-29\" and p.ema_diff_5_35 < p.ema_macd_5));";
#print "50,dma_200,spydma200\n";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
 print "$row[0],$row[1],$row[2],$row[3],$row[4]\n";
} 
 $sth->finish;
 $dbh->disconnect; 
