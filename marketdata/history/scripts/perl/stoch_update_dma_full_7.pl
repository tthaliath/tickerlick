#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
use strict;
use warnings;
my $tickidmin = $ARGV[0];
my $tickidmax = $tickidmin;
my ($tickid,@row);
my $dmaday = 3;
my $dmaday2 = 14;
my ($PASSWORD) = $ENV{DBPASSWORD};
my $dbh = DBI->connect('dbi:mysql:tickmaster','root',$PASSWORD)
 or die "Connection Error: $DBI::errstr\n";
print "Calculating DMA3\n";
my $dma3 = new DMA($dmaday,$dbh);
my $dma14 = new DMA($dmaday2,$dbh);
my $query ="select distinct ticker_id from  tickerprice where ticker_id >= ? and ticker_id <= ? ";
my $sth = $dbh->prepare($query);
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
