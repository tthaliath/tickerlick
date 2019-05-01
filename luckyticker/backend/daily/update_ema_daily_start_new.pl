#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
my ($offset,$dmaday,$offset12,$offset26);
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "Calculating EMA10\n";
my $dma12 = new DMA(12,$dbh);
my $dma26 = new DMA(26,$dbh);
 $query ="select count(1) as cnt, ticker_id from tickerprice group by ticker_id;";
 $sth = $dbh->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array) {
   $offset = $row[0];
   $tickid = $row[1];
   $offset12 = $offset - 12;
   $offset26 = $offset - 26;
#print "$tickid\t $offset\t$offset12\t$offset26\n";
if ($offset12 >= 0)
{
$dma12->setEMA($tickid,$offset12);
}
else
{
print "em12\t$tickid\t$offset12\n";
}

if ($offset26 >= 0)
{
$dma26->setEMA($tickid,$offset26);
}
else
{
print "ema26\t$tickid\t$offset26\n";
}
}


$dbh->disconnect; 
