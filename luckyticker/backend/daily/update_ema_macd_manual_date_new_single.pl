#!/usr/bin/perl

use lib '/home/tthaliath/Tickermain';
use LWP::Simple;
use DBI;
use Webcrawler;
use TickerDB;
use DMAnew;
my ($ticker,%hash,$ret,@rest,$ticker_id,$last_price) ;
print "start\n";
my $webcrawler = new Webcrawler();
#my ($price_date) = $webcrawler->getToday();
my ($price_date) = $ARGV[0];
#print "date:$price_date\n";
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
my $tickerdb = new TickerDB($price_date,$dbh);

#update EMA

$tickid = 11201;
my $tickidmax = 11201;
my $offset = 1;
my $dmaday = 5;
print "Calculating EMA5\n";
my $dma5 = new DMAnew($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
#print "$tickid\t$offset\n";
$dma5->setEMA($tickid,$offset,$price_date);
$tickid++;
}
print "Calculating EMA35\n";
$dmaday = 35;$tickid = 11201;$offset = 1;
my $dma35 = new DMAnew($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
 #print "$tickid\t$offset\n";
 $dma35->setEMA($tickid,$offset,$price_date);
 $tickid++;
}

#update MACD line
print "Calculating MACD line\n";
$tickid = 11201;
$tickerdb->setMACD_5355($tickid,$tickidmax);


#update signal line

$tickid = 11201;
$dmaday = 5;
print "Calculating signal line\n";
my $dma5 = new DMAnew($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
$offset = $dma5->getMACD535Offset($tickid,$price_date);
#print "$tickid\t$offset\n";
if ($offset > 0){$dma5->setEMAMACD535($tickid,$offset,$price_date)};
$tickid++;
}

$dbh->disconnect; 
exit 1;
