#!/usr/bin/perl

use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
$sql = "select b.seq,b.ticker,b.rtq,(b.ema_diff_5_35 - b.ema_macd_5), b.ema_macd_5,b.ema_diff_5_35 from secpricert where ticker = '"$ticker."'.$tprice_date = '".$price_date."' ORDER BY seq DESC limit 5";

 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
 print "$row[0],$row[1],$row[2],$row[3],$row[4],$row[5]\n";
} 
 $sth->finish;
 $dbh->disconnect; 
