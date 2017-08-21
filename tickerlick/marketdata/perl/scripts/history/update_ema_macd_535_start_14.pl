#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
$tickeridmin = $ARGV[0];
$tickeridmax = $tickeridmin;
my $dmaday = 5;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "Calculating macd9\n";
my $dma9 = new DMA($dmaday,$dbh);
while ($tickeridmin <= $tickeridmax)
{
   print "$tickeridmin\n";
   $dma9->setEMAMACD535Start($tickeridmin);
   $tickeridmin++;
}

$dbh->disconnect; 
