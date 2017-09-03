#!/usr/bin/perl
my $proc_order_id = $ARGV[0];
use lib '/home/tthaliath/Tickermain';
use DBI;
use strict;
use warnings;
use DMAStoch;
my $dmaday = 3;
my $dmaday2 = 14;
my ($PASSWORD) = $ENV{DBPASSWORD};
my (@row,$dma14,$dma3,$tickid);
my $dbh = DBI->connect('dbi:mysql:tickmaster','root',$PASSWORD)
 or die "Connection Error: $DBI::errstr\n";
#print "Calculating DMA3\n";
$dma3 = new DMAStoch($dmaday,$dbh);
$dma14 = new DMAStoch($dmaday2,$dbh);
my $query ="select a.ticker_id from  tickermaster a, rtq_proc_master1 b where b.proc_ord_id = ? and a.ticker_id = b.ticker_id  and a.tflag2 = 'Y'";
#print "$query\n";
my $sth = $dbh->prepare($query);
 $sth->execute($proc_order_id) or die "SQL Error: $DBI::errstr\n";
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
