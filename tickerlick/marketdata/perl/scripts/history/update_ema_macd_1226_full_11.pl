#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
my $tickid = $ARGV[0];
my $tickidmax = $tickid;
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
