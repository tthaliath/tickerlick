#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
my $tickid = 1;
$dmaday = 10;
$offset = 204;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
my $dma = new DMA($offset,$dmaday,$dbh);
while ($tickid < 2)
{
 print "$tickid\t$offset\n";
$dma->setDMA($tickid);
$tickid++;
}
$dbh->disconnect; 
