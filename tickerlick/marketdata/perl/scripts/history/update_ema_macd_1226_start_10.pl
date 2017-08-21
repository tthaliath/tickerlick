#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
$tickeridmin = $ARGV[0];
$tickeridmax = $tickeridmin;
my $dmaday = 9;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "Calculating macd9\n";
my $dma9 = new DMA($dmaday,$dbh);
while ($tickeridmin <= $tickeridmax)
{
   print "$tickeridmin\n";
   $dma9->setEMAMACDStart($tickeridmin);
   $tickeridmin++;
}

$dbh->disconnect; 
