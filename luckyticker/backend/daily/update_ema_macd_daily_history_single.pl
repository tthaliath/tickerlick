#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
my $tickid = 1491;
my $dmaday = 9;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "Calculating macd9\n";
my $dma9 = new DMA($dmaday,$dbh);
$offset = $dma9->getMACDOffset($tickid);
#print "$tickid\t$offset\n";
if ($offset > 0){$dma9->setEMAMACD($tickid,$offset)};

$dbh->disconnect; 
