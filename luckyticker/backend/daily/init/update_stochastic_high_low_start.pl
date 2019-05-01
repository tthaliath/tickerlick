#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
my $tickid = 4533;
my $tickidmax = 4533;
my $dmaday = 9;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "Calculating macd9\n";
my $dma9 = new DMA($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
#print "$tickid\n";
$dma9->setEMAMACDStart($tickid);
$tickid++;
}

$dbh->disconnect; 
