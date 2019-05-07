#!/usr/bin/perl

use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql ="select a.price_date, a.close_price, a.dma_10, a.dma_50, a.dma_200,ema_diff,ema_macd_9, (ema_diff - ema_macd_9) as signalstrength,ema_diff_5_35,ema_macd_5, (ema_diff_5_35 - ema_macd_5) as signalstrength2 from tickerprice a where a.ticker_id = 3607 ORDER BY a.price_date DESC LIMIT 0,250";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 print "price_date,close_price,dma_10,dma_50,dma_200,ema_diff,ema_macd_9,signalstrength1,ema_diff_5_35,ema_macd_5,signalstrength2\n";
 while (@row = $sth->fetchrow_array) {
 print "$row[0],$row[1],$row[2],$row[3],$row[4],$row[5],$row[6],$row[7],$row[8],$row[9],$row[10]\n";
} 
 $sth->finish;
 $dbh->disconnect; 
