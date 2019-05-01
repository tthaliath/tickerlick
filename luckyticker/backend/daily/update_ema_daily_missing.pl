#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
use TickerDB;
my (%tickidhash,$tickid);
my $offset = 1;
my $dmaday = 12;
my $price_date = "2012-10-23";
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "retrieving tickers missing ema data\n";
my $tickdb =  new TickerDB($price_date,$dbh);
%tickidhash = $tickdb->getTickersMissingEMA();
print "Calculating EMA10\n";
my $dma12 = new DMA($dmaday,$dbh);
foreach $tickid (keys %tickidhash)
{
print "$tickid\n";
$dma12->setEMA($tickid,$offset);
}
#exit 1;
print "Calculating EMA26\n";
$dmaday = 26;$offset = 1;
my $dma26 = new DMA($dmaday,$dbh);
foreach $tickid (keys %tickidhash)
{
 print "$tickid\n";
 $dma26->setEMA($tickid,$offset);
}


$dbh->disconnect; 
