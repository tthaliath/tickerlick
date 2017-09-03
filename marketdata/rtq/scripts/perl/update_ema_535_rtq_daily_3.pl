#!/usr/bin/perl
use lib '/home/tthaliath/Tickerdaily';
use DBI;
use DMARTQ;
use Util;
use strict;
use warnings;
my $proc_ord_id = $ARGV[0];
my $price_date =$ARGV[1];
my $prev_date = $ARGV[2];
my ($PASSWORD) = $ENV{DBPASSWORD};
my ($ema_5,$ema_35,@row,$seq,@row_diff,$tickid,$offset,$dmaday,$offset12,$offset26,$ema_12,$em_26);
my $dbh = DBI->connect('dbi:mysql:tickmaster','root',$PASSWORD)
 or die "Connection Error: $DBI::errstr\n";
#print "Calculating EMA10\n";
my $dma5 = new DMARTQ(5,$dbh);
my $dma35 = new DMARTQ(35,$dbh);
$offset = 1;
my $query ="select a.ticker_id from  tickermaster a, rtq_proc_master1 b where b.proc_ord_id = ? and a.ticker_id = b.ticker_id  and a.tflag2 = 'Y'";

#print "$query\n";
my $sth = $dbh->prepare($query);
  $sth->execute($proc_ord_id) or die "SQL Error: $DBI::errstr\n";
while (@row = $sth->fetchrow_array) {
  $tickid = $row[0];
#print "$tickid\n";
$dma5->setEMA($tickid,$offset);
$dma35->setEMA($tickid,$offset);
}
 $sth->execute($proc_ord_id) or die "SQL Error: $DBI::errstr\n";
while (@row = $sth->fetchrow_array) 
{
$tickid = $row[0];
#update ema_diff 
my $diff_query ="select ticker_id,seq,ema_5,ema_35 from tickerrtq7 where ticker_id = ? and price_date = ? order by seq desc limit 1";
my $sth_diff = $dbh->prepare($diff_query);
$sth_diff->execute($tickid,$price_date) or die "SQL Error: $DBI::errstr\n";
#print "$diff_query\n";
my $util = new Util($dbh); 
 while (@row_diff = $sth_diff->fetchrow_array) {
   $tickid = $row_diff[0];
   $seq = $row_diff[1];
   $ema_5 = $row_diff[2];
   $ema_35  = $row_diff[3];
   #print "$tickid,$seq,$ema_5, $ema_35\n";
   if ($ema_5 > 0 && $ema_35 > 0) 
   {
      $util->setMACDTickerDate535($tickid,$seq);
   }
$offset = $dma5->getMACD535OffsetRTQ($tickid,$prev_date);
#print "$tickid\t$offset\n";
if ($offset > 0)
{
   $dma5->setEMAMACD535($tickid,$offset);
}
}
$sth_diff->finish();
}
$sth->finish();
$dbh->disconnect; 
