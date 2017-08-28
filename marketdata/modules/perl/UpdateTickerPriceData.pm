#!/usr/bin/perl -w

use lib qw(/home/tickerlick/Tickermain);
use LWP::Simple;
use DBI;
use Webcrawler;
use TickerDB;
use DMA;
use Date::Calc qw(Day_of_Week);
use strict;
use warnings;
#my ($ticker,%hash,$ret,@rest,$last_price) ;

package UpdateTickerPriceData;

sub new
{
    my $class = shift;
     my $self = {};
    bless $self, $class;
    return $self;
}

sub updatecurrentprice
{
my $self = shift;
my $ticker_id = shift;
my $last_price = shift;
my $ticker = shift;
my $webcrawler = new Webcrawler();
my ($price_date) = $webcrawler->getToday();
my ($offset,$dmaday,$dma10,$dma50,$ret,$deletesql,$insertsql,$dma200,$dma12,$dma26,$dma5,$dma35);
#print "date:$price_date\n";
my $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
my $tickerdb = new TickerDB($price_date,$dbh);
$last_price = $webcrawler->getLastPrice($ticker);
#print "last:last_price\n";

if ($last_price && $last_price > 0)
{
   $last_price =~ s/\,//g;
   $ret = $tickerdb->loadPrice($ticker_id,$price_date,$last_price);
   #$retrsi = $tickerdb->loadPricersi($ticker_id,$price_date,$last_price);
 #insert into tickerpricersi
 #if price exists for given date. if exists, delete it first.
 $deletesql = "delete from tickerpricersi where ticker_id = $ticker_id and price_date = '$price_date'";
 $ret = $dbh->do($deletesql);
 $insertsql = "insert into tickerpricersi (ticker_id,price_date,close_price) values ($ticker_id,'$price_date',$last_price)";
 $ret = $dbh->do($insertsql);

#update DMA
 $offset = 0;
 $dmaday = 10;
 #print "Calculating DMA10 for $ticker_id\n";
 $dma10 = new DMA($dmaday,$dbh);
 $dma10->setDMA($ticker_id,$offset);
 #print "Calculating DMA50\n";
 $dmaday = 50;
 $dma50 = new DMA($dmaday,$dbh);
 $dma50->setDMA($ticker_id,$offset);
 #print "Calculating DMA200\n";
 $dmaday = 200;
 $dma200 = new DMA($dmaday,$dbh);
 $dma200->setDMA($ticker_id,$offset);

#update EMA (12,26,9)

 $offset = 1;
 $dmaday = 12;
 #print "Calculating EMA10\n";
 $dma12 = new DMA($dmaday,$dbh);
 $dma12->setEMA($ticker_id,$offset);
 #print "Calculating EMA26\n";
 $dmaday = 26;$offset = 1;
 $dma26 = new DMA($dmaday,$dbh);
 $dma26->setEMA($ticker_id,$offset);

#update MACD line
 #print "Calculating MACD line\n";
 $dmaday = 12; 
 #my $dmamacd = new DMA($dmaday,$dbh);
 #$dmamacd->setMACDSingle($ticker_id,$price_date);
 setMACDSingle($ticker_id,$price_date,$dbh);

#update signal line

 $dmaday = 9;
 #print "Calculating signal line\n";
 my $dma9 = new DMA($dmaday,$dbh);
 $offset = $dma9->getMACDOffset($ticker_id);
 #print "$ticker_id\t$offset\n";
 if ($offset > 0){$dma9->setEMAMACD($ticker_id,$offset)};
 
 #update EMA (5,35,5)

 $offset = 1;
 $dmaday = 5;
 #print "Calculating EMA10\n";
 $dma5 = new DMA($dmaday,$dbh);
 $dma5->setEMA($ticker_id,$offset);
 #print "Calculating EMA26\n";
 $dmaday = 35;$offset = 1;
 $dma35 = new DMA($dmaday,$dbh);
 $dma35->setEMA($ticker_id,$offset);

#update MACD line
 setMACD5355Single($ticker_id,$price_date,$dbh);

#update signal line

 $dmaday = 5;
 #print "Calculating signal line\n";
 $dma5 = new DMA($dmaday,$dbh);
 $offset = $dma5->getMACD535Offset($ticker_id);
 #print "$ticker_id\t$offset\n";
 if ($offset > 0){$dma5->setEMAMACD535($ticker_id,$offset)};


#update RSI

my ($prev_price_date,$prev_close_price,$gain,$loss,$close_price);
my $upd_query ="update tickerpricersi set gain = ?, loss = ? where ticker_id = ? and price_date = ?";
my $sth_upd = $dbh->prepare($upd_query);
my $diff_query ="select price_date,close_price from tickerpricersi where ticker_id = $ticker_id and price_date < $price_date order by price_date desc limit 1" ;
my ($sth_diff,@row_diff, $day_query,$sth_day,@row_day,);
$sth_diff = $dbh->prepare($diff_query);
$sth_diff->execute or die "SQL Error: $DBI::errstr\n";
while (@row_diff = $sth_diff->fetchrow_array)
{
   $prev_price_date = $row_diff[0];
   $prev_close_price = $row_diff[1];
}
$sth_diff->finish();
$day_query ="select close_price from tickerpricersi where ticker_id = $ticker_id and price_date = $price_date" ;

$sth_day = $dbh->prepare($day_query);
$sth_day->execute or die "SQL Error: $DBI::errstr\n";
while (@row_day = $sth_day->fetchrow_array)
{
   $close_price = $row_day[0];
   $gain = 0; $loss = 0;
   if ($close_price > $prev_close_price)
         {
             $gain = $close_price - $prev_close_price;
             $loss = 0;
         }
      else
        {
            $loss = $prev_close_price - $close_price;
            $gain = 0;
        }
        $sth_upd->execute($gain,$loss,$ticker_id,$price_date) or die "SQL Error: $DBI::errstr\n";
}

$sth_day->finish();
$sth_upd->finish();

#update rsi 14
my $prev_avg_query = "select avg_gain,avg_loss from tickerpricersi where ticker_id = ? and price_date < ? order by price_date desc limit 1";
my $cur_avg_query = "select gain,loss from tickerpricersi where ticker_id = ? and price_date = ?";
my $upd_avg_query = "update tickerpricersi set avg_gain = ?, avg_loss = ? ,rsi = ?, rsi_14 = ? where ticker_id = ? and price_date = ?";
my (@row_cur_avg,$rs,$rsi);
my (@row_prev_avg,$prev_avg_gain,$prev_avg_loss,$curr_gain,$curr_loss,$avg_gain,$avg_loss);
my $sth_prev_avg_query = $dbh->prepare($prev_avg_query);
my $sth_cur_avg_query = $dbh->prepare($cur_avg_query);
my $sth_upd_avg_query = $dbh->prepare($upd_avg_query);
#update gain and loss
   $sth_prev_avg_query->execute($ticker_id,$price_date) or die "SQL Error: $DBI::errstr\n";
   while (@row_prev_avg = $sth_prev_avg_query->fetchrow_array)
    {
          $prev_avg_gain = $row_prev_avg[0];
          $prev_avg_loss = $row_prev_avg[1];
    }
    $sth_prev_avg_query->finish();
   $sth_cur_avg_query->execute($ticker_id,$price_date) or die "SQL Error: $DBI::errstr\n";
   while (@row_cur_avg = $sth_cur_avg_query->fetchrow_array)
    {
       $curr_gain = $row_cur_avg[0];
       $curr_loss = $row_cur_avg[1];
       $avg_gain = (($prev_avg_gain  * 13.00) + $curr_gain) / 14.00;
       $avg_loss = (($prev_avg_loss  * 13.00) + $curr_loss) / 14.00;
       if ($avg_gain == 0){$rs = 0;$rsi = 0;}
       elsif ($avg_loss == 0){$rs = 100;$rsi = 100;}
       else
        {
          $rs = $avg_gain/$avg_loss;
          $rsi = 100.00 - (100.00/(1.00+$rs));
        }
            $sth_upd_avg_query->execute($avg_gain,$avg_loss,$rs,$rsi,$ticker_id,$price_date);
            $prev_avg_gain = $avg_gain;
            $prev_avg_loss = $avg_loss;
      #print "$price_date,$first_row_flag,$prev_avg_gain,$prev_avg_loss,$curr_gain, $curr_loss,$avg_gain ,$avg_loss\n";

   }
$sth_cur_avg_query->finish();

#update stochastic;
$dmaday = 3;
my $dmaday2 = 14;
my $dma3 = new DMA($dmaday,$dbh);
my $dma14 = new DMA($dmaday2,$dbh);
#print "<h>starting stochastic</h>";
$dma14->setStochasticDaily($ticker_id);
$dma3->setDMAStochDaily($ticker_id);
$dma3->setDMAStochFullDaily($ticker_id);
#$dbh->disconnect; 
} #eof if price exists
} #eof function

sub getTickerID
{
  my $self = shift;
  my $ticker = shift;
  my $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
  my $query = "select ticker_id from tickermaster where ticker = '$ticker'";
   #print "tom::$query\n";
  my(@row,$ticker_id);
  my $sth = $dbh->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array)
 {
      $ticker_id = $row[0];
 }
  $sth->finish;
  #$dbh->disconnect;
  #if (!$row[0]){return -1;}
  return $ticker_id;
}  

sub setMACDSingle
{
  my ($tickid) = shift;
  my ($price_date) = shift;
  my ($dbh) = shift;
  my($updatemacd,$ret);
 $updatemacd = "update tickerprice set ema_diff = (ema_12 - ema_26) where  ticker_id = $tickid and price_date = '$price_date'";
 #print "$updatemacd\n";
 $ret = $dbh->do($updatemacd) or die "SQL Error: $DBI::errstr\n";
}


sub setMACD5355Single
{
  my ($tickid) = shift;
  my ($price_date) = shift;
  my ($dbh) = shift;
  my($updatemacd,$ret);
 $updatemacd = "update tickerprice set ema_diff_5_35 = (ema_5 - ema_35) where  ticker_id = $tickid and price_date = '$price_date'";
 #print "$updatemacd\n";
 $ret = $dbh->do($updatemacd) or die "SQL Error: $DBI::errstr\n";
}
1;
