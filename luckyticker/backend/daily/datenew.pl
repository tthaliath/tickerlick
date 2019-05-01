#!/usr/bin/perl

use DBI;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
 $sql ="select distinct (price_date) from tickerprice where ticker_id > 11062 order by price_date asc";
#print "50,dma_200,spydma200\n";
print "$sql\n";
 open(OUT,">loadmasternew.sh");
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
 print OUT "./loadpriceargnew.sh '$row[0]'\n";
}
 close (OUT); 
 $sth->finish;
 $dbh->disconnect; 
