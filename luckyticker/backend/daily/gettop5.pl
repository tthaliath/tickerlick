#!/usr/bin/perl

use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql = "select b.seq,b.cr_time,b.ticker,b.rtq,(b.ema_diff_5_35 - b.ema_macd_5), b.ema_macd_5,b.ema_diff_5_35 from (SELECT seq,ticker FROM (SELECT seq,ticker,@ticker_rank := IF(@current_ticker = ticker, @ticker_rank + 1, 1) AS ticker_rank, @current_ticker := ticker FROM secpricert where price_date = '2018-05-01' ORDER BY ticker,seq DESC ) ranked  WHERE ticker_rank <= 5) a, secpricert b where a.seq = b.seq";
 
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
 print "$row[0],$row[1],$row[2],$row[3],$row[4],$row[5],$row[6]\n";
} 
 $sth->finish;
 $dbh->disconnect; 
