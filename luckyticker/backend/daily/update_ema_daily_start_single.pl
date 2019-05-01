#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
my $tickid = 11201;
my $offset = 166;
my $dmaday = 12;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "Calculating EMA10\n";
my $dma12 = new DMA($dmaday,$dbh);
#print "$tickid\t$offset\n";
$dma12->setEMAStart($tickid,$offset);
print "Calculating EMA26\n";
$dmaday = 26;$tickid = 11201;$offset = 136; 
my $dma26 = new DMA($dmaday,$dbh);
 #print "$tickid\t$offset\n";
 $dma26->setEMAStart($tickid,$offset);


$dbh->disconnect; 
