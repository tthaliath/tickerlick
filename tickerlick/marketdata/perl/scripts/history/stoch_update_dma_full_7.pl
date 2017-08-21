#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
my $tickidmin = $ARGV[0];
my $tickidmax = $tickidmin;

my $dmaday = 3;
my $dmaday2 = 14;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "Calculating DMA3\n";
my $dma3 = new DMA($dmaday,$dbh);
my $dma14 = new DMA($dmaday2,$dbh);
$query ="select distinct ticker_id from  tickerprice where ticker_id >= ? and ticker_id <= ? ";
 $sth = $dbh->prepare($query);
 $sth->execute($tickidmin,$tickidmax) or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array)
 {
  $tickid = $row[0];
  print "$tickid\n";
  $dma14->setStochasticHistory($tickid);
  $dma3->setDMAStoch($tickid);
  $dma3->setDMAStochFull($tickid);
}
$sth->finish;
$dbh->disconnect; 
