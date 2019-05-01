#!c:\Perl64\bin\perl

use lib '/home/tthaliath/Tickermain';
use LWP::Simple;
use DBI;
use Webcrawler;
use TickerDB;
use DMA;
my ($ticker,%hash,$ret,@rest,$ticker_id,$last_price) ;
print "start\n";
my $webcrawler = new Webcrawler();
my ($price_date) = $webcrawler->getToday();
#print "date:$price_date\n";
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
my $tickerdb = new TickerDB($price_date,$dbh);
open (F, ">noprice.txt");
open (IN,"<ustickerfinal.csv");
while (<IN>)
{
  chomp;
  ($ticker_id,$ticker,@rest) = split(/\,/,$_);
   $ticker =~ s/ //g;
   $hash{$ticker_id} = $ticker;
}
close (IN);
foreach $ticker_id (keys %hash)
{
  $ticker = $hash{$ticker_id};
  $last_price = $webcrawler->getLastPrice($ticker);
  if ($last_price && $last_price > 0)
  {
    $ret = $tickerdb->loadPrice($ticker_id,$price_date,$last_price);
  }
  else
  {
    print F "$ticker_id\t$ticker\t$price_date\n";
  }
  
}
close (F);

#update DMA
my $tickid = 1;
my $tickidmax = $tickerdb->getTickerIDMax();
print "max:$tickidmax\n";
my $offset = 0;
my $dmaday = 10;
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

#update EMA

$tickid = 1;
my $offset = 1;
my $dmaday = 12;
print "Calculating EMA10\n";
my $dma12 = new DMA($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
#print "$tickid\t$offset\n";
$dma12->setEMA($tickid,$offset);
$tickid++;
}
print "Calculating EMA26\n";
$dmaday = 26;$tickid = 1;$offset = 1;
my $dma26 = new DMA($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
 #print "$tickid\t$offset\n";
 $dma26->setEMA($tickid,$offset);
 $tickid++;
}

#update MACD line
print "Calculating MACD line\n";
my $dma9 = new DMA($dmaday,$dbh);
$dma9->setMACD($price_date);


#update signal line

$tickid = 1;
$dmaday = 9;
print "Calculating signal line\n";
my $dma9 = new DMA($dmaday,$dbh);
while ($tickid <= $tickidmax)
{
$offset = $dma9->getMACDOffset($tickid);
#print "$tickid\t$offset\n";
if ($offset > 0){$dma9->setEMAMACD($tickid,$offset)};
$tickid++;
}

$dbh->disconnect; 
exit 1;
