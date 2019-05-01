#!/usr/bin/perl

use DBI;
my ($price_date) = $ARGV[0];
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql ="select b.ticker_id,b.ticker,b.comp_name,b.sector,b.industry from tickermaster b,tickerprice a where a.ema_diff_5_35 < a.ema_macd_5 and a.price_date = \"$ARGV[0]\" and a.ticker_id = b.ticker_id and exists (select 1 from tickerprice p where p.ticker_id = a.ticker_id and p.price_date = \"$ARGV[1]\" and p.ema_diff_5_35 > p.ema_macd_5) order by b.ticker asc;";
 #print "$sql\n";

 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
 #print OUT "$row[0],$row[1],$row[2],$row[3],$row[4]\n";
 my $ins_sql = "insert into report (ticker_id,report_flag) values ($row[0],'MBE')";
 $ret = $dbh->do($ins_sql); 
 $ins_sql = "insert into reporthistory (ticker_id,report_flag,report_date) values ($row[0],'MBE','$price_date')";
 $ret = $dbh->do($ins_sql);
}
 $sth->finish;
 $dbh->disconnect; 
