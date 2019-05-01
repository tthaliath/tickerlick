#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMAnew;
use TickerDB;
my $tickid = 11063;
my $tickidmax = 11608;
my $offset = 1;
my $dmaday = 12;

my ($price_date) = $ARGV[0];
if (!$price_date)
{
  print "Please enter price date as a command lin argument\n";
  exit 1;
}
print "Price date:$price_date\n";
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
my $tickerdb = new TickerDB($price_date,$dbh);
print "Calculating EMA12\n";
my $dma12 = new DMAnew($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
#print "$tickid\t$offset\n";
$dma12->setEMA($tickid,$offset,$price_date);
$tickid++;
}
print "Calculating EMA26\n";
$dmaday = 26;$tickid = 11063;$offset = 1;
my $dma26 = new DMAnew($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
 #print "$tickid\t$offset\n";
 $dma26->setEMA($tickid,$offset,$price_date);
 $tickid++;
}
#update ema diff for MACD 1226
print "Calculating MACD line\n";
$tickid = 11063;
$tickerdb->setMACD_12269($tickid,$tickidmax);
$dbh->disconnect; 
