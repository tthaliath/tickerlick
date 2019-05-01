#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
my $dmaday = 3;
my $dmaday2 = 14;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "Calculating DMA3\n";
my $dma3 = new DMA($dmaday,$dbh);
my $dma14 = new DMA($dmaday2,$dbh);
my $query ="select distinct ticker_id from  tickerprice order by ticker_id";
 $sth = $dbh->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array)
 {
  $tickid = $row[0];
  #print "$tickid\n";
  $dma14->setStochasticDaily($tickid);
  $dma3->setDMAStochDaily($tickid);
  $dma3->setDMAStochFullDaily($tickid);
}
$sth->finish;
$dbh->disconnect; 
