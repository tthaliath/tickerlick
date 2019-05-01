#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
my ($tickid);
my $dmaday = 9;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
or die "Connection Error: $DBI::errstr\n";
print "Calculating macd9\n";
my $dma9 = new DMA($dmaday,$dbh);
open (F, "<2.txt");
while (<F>)
{
chomp;
$tickid = $_;
print "$tickid\n";
$dma9->setEMAMACDStart($tickid);
}

$dbh->disconnect; 
