#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
my $tickid = $ARGV[0];
my $tickidmax = $tickid;
my $dmaday = 10;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "Calculating DMA10\n";
my $dma10 = new DMA($dmaday,$dbh);
my $reccount = $dma10->getreccount($tickid);
my $offset = $reccount - 10;
while ($tickid <= $tickidmax)
{
#print "$tickid\t$offset\n";
$dma10->setDMA($tickid,$offset);
$tickid++;
}
print "Calculating DMA20\n";
$offset = $reccount - 20;
$dmaday = 20;
$tickid = $tickidmax;
my $dma20 = new DMA($dmaday,$dbh);
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
 print "$tickid\t$offset\n";
   $dma20->setDMASD($tickid,$offset);
      $tickid++;
}
print "Calculating DMA50\n";
$offset = $reccount - 50;
$dmaday = 50;
$tickid = $tickidmax;
my $dma50 = new DMA($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
 #print "$tickid\t$offset\n";
 $dma50->setDMA($tickid,$offset);
 $tickid++;
}
print "Calculating DMA200\n";
$offset = $reccount - 200;
$dmaday = 200;
$tickid = $tickidmax;
my $dma200 = new DMA($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
 #print "$tickid\t$offset\n";
 $dma200->setDMA($tickid,$offset);
 $tickid++;
}

$dbh->disconnect; 
