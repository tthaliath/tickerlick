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
my $dma12 = new DMA(12,$dbh);
my $dma26 = new DMA(26,$dbh);
 $query ="select count(*) as cnt, ticker_id from tickerprice where ticker_id >= $tickeridmin and ticker_id <= $tickeridmax group by ticker_id";
 $sth = $dbh->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array) {
   $offset = $row[0];
   $tickid = $row[1];
   $offset12 = $offset - 12;
   $offset26 = $offset - 26;
print "$tickid\t$offset\t$offset12\t$offset26\n";
if ($offset12 >= 0)
{
$dma12->setEMA($tickid,$offset12);
}
else
{
print "missing:em12\t$tickid\t$offset12\n";
}

if ($offset26 >= 0)
{
$dma26->setEMA($tickid,$offset26);
}
else
{
print "missing:ema26\t$tickid\t$offset26\n";
}
}

#update ema_diff 
my $diff_query ="select ticker_id,price_date,ema_12,ema_26 from tickerprice where ticker_id >= $tickeridmin and ticker_id <= $tickeridmax order by ticker_id";
my $sth_diff = $dbh->prepare($diff_query);
$sth_diff->execute or die "SQL Error: $DBI::errstr\n";
#print "$diff_query\n";
my $util = new Util($dbh); 
 while (@row_diff = $sth_diff->fetchrow_array) {
   $tickid = $row_diff[0];
   $price_date = $row_diff[1];
   $ema_12 = $row_diff[2];
   $ema_26  = $row_diff[3];
   if ($ema_12 > 0 && $ema_26 > 0) 
   {
      $util->setMACDTickerDate($tickid,$price_date);
   }
}
$sth->finish();
$sth_diff->finish();
$dbh->disconnect; 
