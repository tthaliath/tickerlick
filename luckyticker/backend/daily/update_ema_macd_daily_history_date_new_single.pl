#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMAnew;
my $tickid = 11201;
my $tickidmax = 11201;
my $dmaday = 9;
my ($price_date) = $ARGV[0];
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "Calculating macd9\n";
my $dma9 = new DMAnew($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
$offset = $dma9->getMACDOffset($tickid,$price_date);
#print "$tickid\t$offset\n";
if ($offset > 0){$dma9->setEMAMACD($tickid,$offset,$price_date)};
$tickid++;
}

$dbh->disconnect; 
