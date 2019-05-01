#!/usr/bin/perl

use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql ="select b.ticker_id,b.ticker,( a.ema_diff_5_35 - a.ema_macd_5) as histogram,b.comp_name,b.sector,b.industry from tickermaster b,tickerprice a where ( a.ema_diff_5_35 - a.ema_macd_5) < 0 and ( a.ema_diff_5_35 - a.ema_macd_5) >= -1 and a.price_date = \"2012-11-23\" and a.ticker_id = b.ticker_id and exists (select 1 from tickerprice p where p.ticker_id = a.ticker_id and p.price_date = \"2012-11-21\" and p.ema_diff_5_35 > p.ema_macd_5) order by b.ticker asc;";
#print "50,dma_200,spydma200\n";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
 print "$row[0],$row[1],$row[2],$row[3],$row[4],$row[5]\n";
} 
 $sth->finish;
 $dbh->disconnect; 
