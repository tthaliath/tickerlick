#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMAnew;
my $tickid = 11063;
my $tickidmax = 11608;
my $offset = 0;
my $dmaday = 10;
my ($price_date) = $ARGV[0];
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "Calculating DMA10\n";
my $dma10 = new DMAnew($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
#print "$tickid\t$offset\n";
$dma10->setDMA($tickid,$offset,$price_date);
$tickid++;
}
print "Calculating DMA50\n";
$dmaday = 50;$tickid = 11063;$offset = 0;
my $dma50 = new DMAnew($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
 #print "$tickid\t$offset\n";
 $dma50->setDMA($tickid,$offset,$price_date);
 $tickid++;
}
print "Calculating DMA200\n";
$dmaday = 200;$tickid = 11063;$offset=0;
my $dma200 = new DMAnew($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
 #print "$tickid\t$offset\n";
 $dma200->setDMA($tickid,$offset,$price_date);
 $tickid++;
}

$dbh->disconnect; 
