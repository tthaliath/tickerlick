#!/usr/bin/perl
use lib '/home/tthaliath/Tickermain';
use DBI;
use DMA;
use Util;
my ($offset,$dmaday,$offset12,$offset26,$tickeridmin,$tickeridmax,$ema_12,$em_26);
$tickeridmin = $ARGV[0];
$tickeridmax = $tickeridmin;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
print "Calculating EMA10\n";
my $dma5 = new DMA(5,$dbh);
my $dma35 = new DMA(35,$dbh);
 $query ="select count(*) as cnt, ticker_id from tickerprice where ticker_id >= $tickeridmin and ticker_id <= $tickeridmax group by ticker_id";
 $sth = $dbh->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array) {
   $offset = $row[0];
   $tickid = $row[1];
   $offset5 = $offset - 5;
   $offset35 = $offset - 35;
print "$tickid\t$offset\t$offset5\t$offset35\n";
if ($offset5 >= 0)
{
$dma5->setEMA($tickid,$offset5);
}
else
{
print "missing:em5\t$tickid\t$offset5\n";
}

if ($offset35 >= 0)
{
$dma35->setEMA($tickid,$offset35);
}
else
{
print "missing:ema35\t$tickid\t$offset35\n";
}
}

#update ema_diff 
my $diff_query ="select ticker_id,price_date,ema_5,ema_35 from tickerprice where ticker_id >= $tickeridmin and ticker_id <= $tickeridmax order by ticker_id";
my $sth_diff = $dbh->prepare($diff_query);
$sth_diff->execute or die "SQL Error: $DBI::errstr\n";
#print "$diff_query\n";
my $util = new Util($dbh); 
 while (@row_diff = $sth_diff->fetchrow_array) {
   $tickid = $row_diff[0];
   $price_date = $row_diff[1];
   $ema_5 = $row_diff[2];
   $ema_35  = $row_diff[3];
   if ($ema_5 > 0 && $ema_35 > 0) 
   {
      $util->setMACDTickerDate535($tickid,$price_date);
   }
}
$sth->finish();
$sth_diff->finish();
$dbh->disconnect; 
