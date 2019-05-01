#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMASD;
my $tickid = 2424; 
my $offset = 1115;
my $dmaday = 10;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "Calculating DMA10\n";
my $dma10 = new DMASD($dmaday,$dbh);
#print "$tickid\t$offset\n";
$dma10->setDMASDVOL10($tickid,$offset);
$dmaday = 20;
my $dma20 = new DMASD($dmaday,$dbh);
$dma20->setDMASDVOL20($tickid,$offset);
$dbh->disconnect; 
