#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
my $tickid = 1;
my $tickidmax = 14448;
my $offset = 0;
my $dmaday = 10;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "Calculating DMA10\n";
my $dma10 = new DMA($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
#print "$tickid\t$offset\n";
$dma10->setDMA($tickid,$offset);
$tickid++;
}
print "Calculating DMA20\n";
$dmaday = 20;$tickid = 1;$offset = 0;
my $dma20 = new DMA($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
 #print "$tickid\t$offset\n";
  $dma20->setDMA($tickid,$offset);
   $tickid++;
}
print "Calculating bollinger band sd\n";
$tickid = 1;
$offset = 0;
while ($tickid <= $tickidmax)
{
 #print "$tickid\t$offset\n";
   $dma20->setDMASD($tickid,$offset);
      $tickid++;
}
print "Calculating DMA50\n";
$dmaday = 50;$tickid = 1;$offset = 0;
my $dma50 = new DMA($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
 #print "$tickid\t$offset\n";
 $dma50->setDMA($tickid,$offset);
 $tickid++;
}
print "Calculating DMA200\n";
$dmaday = 200;$tickid = 1;$offset=0;
my $dma200 = new DMA($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
 #print "$tickid\t$offset\n";
 $dma200->setDMA($tickid,$offset);
 $tickid++;
}

$dbh->disconnect; 
