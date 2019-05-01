#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
my $tickid = 4031;
my $tickidmax = 6004;
my $offset = 243;
my $dmaday = 12;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "Calculating EMA10\n";
my $dma12 = new DMA($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
#print "$tickid\t$offset\n";
$dma12->setEMAStart($tickid,$offset);
$tickid++;
}
print "Calculating EMA26\n";
$dmaday = 26;$tickid = 1;$offset = 229;
my $dma26 = new DMA($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
 #print "$tickid\t$offset\n";
 $dma26->setEMAStart($tickid,$offset);
 $tickid++;
}


$dbh->disconnect; 
