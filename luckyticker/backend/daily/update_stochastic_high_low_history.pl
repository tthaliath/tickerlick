#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
my $tickid = 9;
my $tickidmax = 9;
my $dmaday = 14;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "Calculating Stochastic 14\n";
my $dma14 = new DMA($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
$offset = $dma14->getStochasticOffset($tickid);
print "$tickid\t$offset\n";
if ($offset > 0){$dma14->setStochastic($tickid,$offset)};
$tickid++;
}

$dbh->disconnect; 
