#!/usr/bin/perl
my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);####
#print  "$day,$month,$yr19\n";
#print "Date:\t$day-".++$month. "-".($yr19+1900)."\n"; 
#$str = ($yr19+1900)."-".++$month. "-".$day;
$str = $ARGV[0];
print "$str\n";
exit 1;
#2012-09-25
exit 1;
use DBI;
my $tickid = 1;
$dmaday = 10;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
while ($tickid < 524)
{
$offset = 164;
 print "$tickid\t$offset\n";
while ($offset >= 0)
{
 $sql ="SELECT avg(close_price) AS avg_prc, max(price_date) as pdate,count(1) as rec_cnt FROM (SELECT close_price, price_date FROM tickerprice WHERE ticker_id = $tickid ORDER BY price_date DESC LIMIT $offset,10) AS abc;
";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$tickid\t$offset\t$sql\n";
 while (@row = $sth->fetchrow_array) {
 #print "$row[0]\t$row[1]\t$offset\n";
 if ($dmaday != $row[2]){next;}
 $sql = "update tickerprice set dma_10 = $row[0] where ticker_id = $tickid and price_date = '$row[1]'";
;
 $ret = $dbh->do($sql);
} 
$offset--;
}
$tickid++;
}
 $sth->finish;
 $dbh->disconnect; 
