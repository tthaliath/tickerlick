#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
my $tickid = 1;
my $tickidmax = 14448;
my $dmaday = 9;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "Calculating macd9\n";
my $dma9 = new DMA($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
$offset = $dma9->getMACDOffset($tickid);
#print "$tickid\t$offset\n";
if ($offset > 0){$dma9->setEMAMACD($tickid,$offset)};
$tickid++;
}

$dbh->disconnect; 
