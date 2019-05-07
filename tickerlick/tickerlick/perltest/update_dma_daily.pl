#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
my $tickid = 1;
my $tickidmax = 523;
my $dmaday = 10;
my $offset = 0;
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
print "Calculating DMA50\n";
$dmaday = 50;$tickid = 1;
my $dma50 = new DMA($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
 #print "$tickid\t$offset\n";
 $dma50->setDMA($tickid,$offset);
 $tickid++;
}
print "Calculating DMA200\n";
$dmaday = 200;$tickid = 1;
my $dma200 = new DMA($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
 #print "$tickid\t$offset\n";
 $dma200->setDMA($tickid,$offset);
 $tickid++;
}

$dbh->disconnect; 
