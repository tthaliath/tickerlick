#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
use strict;
use warnings;
my $tickeridmin = $ARGV[0];
my $tickeridmax = $tickeridmin;
my $dmaday = 5;
my ($PASSWORD) = $ENV{DBPASSWORD};
my $dbh = DBI->connect('dbi:mysql:tickmaster','root',$PASSWORD)
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
