#!c:\Perl64\bin\perl

use lib qw(/home/tickerlick/Tickermain);
use LWP::Simple;
use DBI;
use Webcrawler;
use TickerDB;
use DMA;
my ($ticker,%hash,$ret,@rest,$ticker_id,$last_price) ;

sub updatecurrentprice
{
$ticker_id = shift;
$last_price = shift;
my $webcrawler = new Webcrawler();
my ($price_date) = $webcrawler->getToday();
#print "date:$price_date\n";
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
my $tickerdb = new TickerDB($price_date,$dbh);
#$last_price = $webcrawler->getLastPrice($ticker);
if ($last_price && $last_price > 0)
{
   $ret = $tickerdb->loadPrice($ticker_id,$price_date,$last_price);

#update DMA
 my $offset = 0;
 my $dmaday = 10;
 #print "Calculating DMA10 for $ticker_id\n";
 my $dma10 = new DMA($dmaday,$dbh);
 $dma10->setDMA($ticker_id,$offset);
 #print "Calculating DMA50\n";
 $dmaday = 50;
 my $dma50 = new DMA($dmaday,$dbh);
 $dma50->setDMA($ticker_id,$offset);
 #print "Calculating DMA200\n";
 $dmaday = 200;
 my $dma200 = new DMA($dmaday,$dbh);
 $dma200->setDMA($ticker_id,$offset);

#update EMA

 my $offset = 1;
 my $dmaday = 12;
 #print "Calculating EMA10\n";
 my $dma12 = new DMA($dmaday,$dbh);
 $dma12->setEMA($ticker_id,$offset);
 #print "Calculating EMA26\n";
 $dmaday = 26;$offset = 1;
 my $dma26 = new DMA($dmaday,$dbh);
 $dma26->setEMA($ticker_id,$offset);

#update MACD line
 #print "Calculating MACD line\n";
  my $dma9 = new DMA($dmaday,$dbh);
 $dma9->setMACDSingle($price_date);

#update signal line

 $dmaday = 9;
 #print "Calculating signal line\n";
 my $dma9 = new DMA($dmaday,$dbh);
 $offset = $dma9->getMACDOffset($ticker_id);
#print "$ticker_id\t$offset\n";
 if ($offset > 0){$dma9->setEMAMACD($ticker_id,$offset)};

$dbh->disconnect; 
} #eof if price exists
} #eof function

sub getTickerID
{
  my $ticker = shift;
  my $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
  $query = "select ticker_id from tickermaster where ticker = '$ticker'";
   #print "tom::$query\n";
  $sth = $dbh->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array)
 {
      $ticker_id = $row[0];
 }
  $sth->finish;
  $dbh->disconnect;
  #if (!$row[0]){return -1;}
  return $ticker_id;
}  
1;
