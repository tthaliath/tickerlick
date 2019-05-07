#!/usr/bin/perl

use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql ="select b.ticker,b.comp_name,b.sector,b.industry,a.close_price,a.dma_10,a.dma_50,a.dma_200 from tickermaster b,tickerprice a where a.ema_diff_5_35 > a.ema_macd_5 and a.price_date = \"$ARGV[0]\" and a.ticker_id = b.ticker_id and exists (select 1 from tickerprice p where p.ticker_id = a.ticker_id and p.price_date = \"$ARGV[1]\" and p.ema_diff_5_35 < p.ema_macd_5) order by b.ticker asc;";
#print "50,dma_200,spydma200\n";
print "$sql\n";
 my $file = "bull-535-".$ARGV[0]."\.csv";
 print "$file\n";
 open(OUT,">bull/$file");
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 print OUT "ticker,companyname,sector,industry,closeprice,dma10,dma50,dma200\n";
 while (@row = $sth->fetchrow_array) {
 print OUT  "$row[0],$row[1],$row[2],$row[3],$row[4],$row[5],$row[6],$row[7]\n";
}
 close (OUT); 
 $sth->finish;
 $dbh->disconnect; 
