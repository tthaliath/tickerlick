#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
my $tickid = 1491;
my $offset = 248;
my $dmaday = 12;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "Calculating EMA12\n";
my $dma12 = new DMA($dmaday,$dbh);
#print "$tickid\t$offset\n";
$dma12->setEMA($tickid,$offset);
print "Calculating EMA26\n";
$dmaday = 26;$tickid = 1491;$offset = 234;
my $dma26 = new DMA($dmaday,$dbh);
 #print "$tickid\t$offset\n";
 $dma26->setEMA($tickid,$offset);


$dbh->disconnect; 
