#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
my $tickid = $ARGV[0];
my $tickidmax = $tickid;
my $dmaday = 20;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "Calculating DMA20\n";
$tickid = $tickidmax;
my $dma20 = new DMA($dmaday,$dbh);
my $reccount = $dma20->getreccount($tickid);
$offset = $reccount -20;
while ($tickid <= $tickidmax)
{
 #print "$tickid\t$offset\n";
  $dma20->setDMA($tickid,$offset);
   $tickid++;
}
print "Calculating bollinger band sd\n";
$offset = $reccount - 20;
$dmaday = 20;
$tickid = $tickidmax;
my $dma20 = new DMA($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
 #print "$tickid\t$offset\n";
   $dma20->setDMASD($tickid,$offset);
      $tickid++;
}

$dbh->disconnect; 
