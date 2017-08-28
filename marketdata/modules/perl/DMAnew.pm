#!/usr/bin/perl -w
use DBI;
use strict;
use warnings;
package DMAnew;

our ($ema12const,$ema26const,$ema9const,$ema5const,$ema35const);

$ema26const = 0.074074;
$ema12const = 0.153846;
$ema9const = 0.2;
$ema5const = 0.333333;
$ema35const = 0.055556;
sub new
{
    my $class = shift;
     my $self = {
        dmadays  => shift,
        dbh => shift,
    };

    bless $self, $class;
    return $self;
}

sub setDMA
{
  my ($self) = shift;
  my ($tickid) = shift;
  my ($offset) = shift;
  my ($pricedate) = shift;
  my ($query,$updatedma,$sth,@row,$ret);
  while ($offset >= 0)
 {
  
 $query ="SELECT avg(close_price) AS avg_prc, max(price_date) as pdate,count(1) as rec_cnt FROM (SELECT close_price, price_date FROM tickerprice WHERE ticker_id = $tickid and price_date <= '$pricedate' ORDER BY price_date DESC LIMIT $offset,$self->{dmadays}) AS abc;";
 #print "$query\n";
 $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array) {
 #print "$row[0]\t$row[1]]\t$row[2]\n";
 if ($self->{dmadays} != $row[2]){next;}
 $updatedma = "update tickerprice set dma_$self->{dmadays} = $row[0] where ticker_id = $tickid and price_date = '$row[1]'";
 #print "$updatedma\n";
 $ret = $self->{dbh}->do($updatedma);
} 
$offset--;
$sth->finish;
}
}

sub setEMAStart
{
  my ($self) = shift;
  my ($tickid) = shift;
  my ($offset) = shift;
  my ($pricedate) = shift;
  my ($query,$updatedma,$sth,@row,$ret,$avg_price,$ema);
  
 $query ="SELECT avg(close_price) AS avg_prc, max(price_date) as pdate,count(1) as rec_cnt FROM (SELECT close_price, price_date FROM tickerprice WHERE ticker_id = $tickid and price_date <= '$pricedate' ORDER BY price_date DESC LIMIT $offset,$self->{dmadays}) AS abc;";
 $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array) {
 #print "$row[0]\t$row[1]]\t$row[2]\n";
 if ($self->{dmadays} != $row[2]){next;}
 
 $updatedma = "update tickerprice set ema_$self->{dmadays} = $row[0] where ticker_id = $tickid and price_date = '$row[1]'";
 #print "$updatedma\n";
 $ret = $self->{dbh}->do($updatedma);
 }
$sth->finish;
}

sub setEMA
{
  my ($self) = shift;
  my ($tickid) = shift;
  my ($offset) = shift;
  my ($pricedate) = shift;
  my ($query,$updatedma,$sth,$sth2,@row,$ret,$avg_price,$ema,$emaconst,$ema_prev,$update_ema,$curr_price,$curr_date,$curr_row);
  if ($self->{dmadays} == 26)
 {
    $emaconst = $ema26const;
 }
 elsif ($self->{dmadays} == 12)
 {
    $emaconst = $ema12const;
 }
 elsif ($self->{dmadays} == 5)
 {
    $emaconst = $ema5const;
 }
 elsif ($self->{dmadays} == 35)
 {
    $emaconst = $ema35const;
 }
 else
 {
    return;
 }
  while ($offset > 0)
 {
 $query ="SELECT ema_$self->{dmadays} as ema_prev FROM tickerprice WHERE ticker_id = $tickid and price_date <= '$pricedate' ORDER BY price_date DESC LIMIT $offset,1;";
 $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array)
 {
 if (!$row[0]){next;}
 else
 {
    $ema_prev = $row[0];
 }
 #calculate ema
 if ($self->{dmadays} == 26)
 {
    $emaconst = $ema26const;
 }
 elsif ($self->{dmadays} == 12)
 {
    $emaconst = $ema12const;
 }
 elsif ($self->{dmadays} == 5)
 {
    $emaconst = $ema5const;
 }
 elsif ($self->{dmadays} == 35)
 {
    $emaconst = $ema35const;
 }
 $curr_row = $offset - 1;
 $query ="SELECT close_price,price_date FROM tickerprice WHERE ticker_id = $tickid and price_date <= '$pricedate' ORDER BY price_date DESC LIMIT $curr_row,1;";
 $sth2 = $self->{dbh}->prepare($query);
 $sth2->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth2->fetchrow_array) 
  {
 if ($row[0]){
    $curr_price = $row[0];
    $curr_date = $row[1];
    #EMA: {Close - EMA(previous day)} x multiplier + EMA(previous day). 
    $ema = (($curr_price - $ema_prev) * $emaconst) + $ema_prev;
    $update_ema = "update tickerprice set ema_$self->{dmadays} = $ema where ticker_id = $tickid and price_date = '$curr_date'";
    $ret = $self->{dbh}->do($update_ema) or die "SQL Error: $DBI::errstr\n";
   }
  }
  $sth2->finish();
 }
 $offset--;
 $sth->finish();
}
}


sub setEMAMACDStart
{
  my ($self) = shift;
  my ($tickid) = shift;
  my ($pricedate) = shift;
  my ($offset);
  my ($query,$updatedma,$sth,@row,$ret,$avg_price,$ema,$price_date);
  #calculate $offset
  $query = "select count(1) as cnt,min(price_date) as pdate from tickerprice where ticker_id = $tickid and price_date <= '$pricedate' and ema_diff is not null";
  $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array)
 {
      $offset = $row[0];
      $price_date = $row[1];
 }
  $sth->finish;
  #9 day EMA of MACD
  $offset = $offset -9;
  if ($offset < 0){
  #print "offset < 0:$tickid\n";
  return;}
 $query ="SELECT avg(ema_diff) AS avg_ema, max(price_date) as pdate,count(1) as rec_cnt FROM (SELECT ema_diff, price_date FROM tickerprice WHERE ticker_id = $tickid and price_date >= '$price_date' and price_date <=  '$pricedate' ORDER BY price_date DESC LIMIT $offset,$self->{dmadays}) AS abc;";
 $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array) {
 #print "$row[0]\t$row[1]]\t$row[2]\n";
 if ($self->{dmadays} != $row[2]){next;}
 
 $updatedma = "update tickerprice set ema_macd_9 = $row[0] where ticker_id = $tickid and price_date = '$row[1]'";
 #print "$updatedma\n";
 $ret = $self->{dbh}->do($updatedma);
 }
$sth->finish;
}

sub setEMAMACD
{
  my ($self) = shift;
  my ($tickid) = shift;
  my ($offset) = shift;
  my ($pricedate) = shift;
  my ($query,$sth,$sth2,@row,$ret,$avg_price,$ema_macd,$ema_macd_prev,$update_ema_macd,$curr_price,$curr_date,$curr_row,$curr_macd,$ema_const);
  while ($offset > 0)
 {
 $query ="SELECT ema_macd_9 as ema_macd_prev FROM tickerprice WHERE ticker_id = $tickid and price_date <= '$pricedate' ORDER BY price_date DESC LIMIT $offset,1;";
 $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array)
 {
 #print "$row[0]\t$row[1]]\t$row[2]\n";
 if (!$row[0]){next;}
 else
 {
    $ema_macd_prev = $row[0];
 }
 $curr_row = $offset - 1;
 $query ="SELECT ema_diff,price_date FROM tickerprice WHERE ticker_id = $tickid  and price_date <= '$pricedate' ORDER BY price_date DESC LIMIT $curr_row,1;";
 #print "$query\n";
 $sth2 = $self->{dbh}->prepare($query);
 $sth2->execute or die "SQL Error: $DBI::errstr\n";
 #print "tom\n";
 while (@row = $sth2->fetchrow_array) 
  {
 #print "$row[0]\t$row[1]\n";
 if ($row[0]){
    $curr_macd = $row[0];
    $curr_date = $row[1];
    #EMA: {Close - EMA(previous day)} x multiplier + EMA(previous day). 
    $ema_macd = (($curr_macd - $ema_macd_prev) * $ema9const) + $ema_macd_prev;
    $update_ema_macd = "update tickerprice set ema_macd_9 = $ema_macd where ticker_id = $tickid and price_date = '$curr_date'";
 #print "$update_ema_macd\n";
    $ret = $self->{dbh}->do($update_ema_macd) or die "SQL Error: $DBI::errstr\n";
   }
  }
  $sth2->finish();
 }
 $offset--;
 $sth->finish();
}
}

sub getMACDOffset
{

  my ($self) = shift;
  my ($tickid) = shift;
  my ($pricedate) = shift;
  my ($offset);
  my ($query,$updatedma,$sth,@row,$ret,$avg_price,$ema,$price_date);
  #calculate $offset
  $query = "select max(price_date) from tickerprice where ticker_id = $tickid and price_date <= '$pricedate' and ema_macd_9 is not null";
  $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 $price_date = "2222-12-12";
 while (@row = $sth->fetchrow_array)
 {
      $price_date = $row[0];
 }
  $sth->finish;
  #if (!$row[0]){return -1;}
 $query = " select count(1) from tickerprice where ticker_id = $tickid and price_date > '$price_date' and price_date <= '$pricedate' ";
  $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array)
 {
      $offset = $row[0];
 }
  $sth->finish; 

  #9 day EMA of MACD
  return $offset;   
}

sub setEMAMACD535Start
{
  my ($self) = shift;
  my ($tickid) = shift;
  my ($pricedate) = shift;
  my ($offset);
  my ($query,$updatedma,$sth,@row,$ret,$avg_price,$ema,$price_date);
  #calculate $offset
  $query = "select count(1) as cnt,min(price_date) as pdate from tickerprice where ticker_id = $tickid and price_date <= '$pricedate' and ema_diff_5_35 is not null";
  $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array)
 {
      $offset = $row[0];
      $price_date = $row[1];
 }
  $sth->finish;
  #9 day EMA of MACD
  $offset = $offset -5;
  if ($offset < 0){
  #print "offset < 0:$tickid\n";
  return;}
 $query ="SELECT avg(ema_diff_5_35) AS avg_ema, max(price_date) as pdate,count(1) as rec_cnt FROM (SELECT ema_diff_5_35, price_date FROM tickerprice WHERE ticker_id = $tickid and price_date >= '$price_date' and  price_date <= '$pricedate' ORDER BY price_date DESC LIMIT $offset,$self->{dmadays}) AS abc;";
 $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array) {
 #print "$row[0]\t$row[1]]\t$row[2]\n";
 if ($self->{dmadays} != $row[2]){next;}
 
 $updatedma = "update tickerprice set ema_macd_5 = $row[0] where ticker_id = $tickid and price_date = '$row[1]'";
 #print "$updatedma\n";
 $ret = $self->{dbh}->do($updatedma);
 }
$sth->finish;
}

sub setEMAMACD535
{
  my ($self) = shift;
  my ($tickid) = shift;
  my ($offset) = shift;
  my ($pricedate)= shift;
  my ($query,$sth,$sth2,@row,$ret,$avg_price,$ema_macd,$ema_macd_prev,$update_ema_macd,$curr_price,$curr_date,$curr_row,$curr_macd,$ema_const);
  while ($offset > 0)
 {
 $query ="SELECT ema_macd_5 as ema_macd_prev FROM tickerprice WHERE ticker_id = $tickid and price_date <= '$pricedate' ORDER BY price_date DESC LIMIT $offset,1;";
 $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array)
 {
 #print "$row[0]\t$row[1]]\t$row[2]\n";
 if (!$row[0]){next;}
 else
 {
    $ema_macd_prev = $row[0];
 }
 $curr_row = $offset - 1;
 $query ="SELECT ema_diff_5_35,price_date FROM tickerprice WHERE ticker_id = $tickid and price_date <= '$pricedate' ORDER BY price_date DESC LIMIT $curr_row,1;";
 #print "$query\n";
 $sth2 = $self->{dbh}->prepare($query);
 $sth2->execute or die "SQL Error: $DBI::errstr\n";
 #print "tom\n";
 while (@row = $sth2->fetchrow_array) 
  {
 #print "$row[0]\t$row[1]\n";
 if ($row[0]){
    $curr_macd = $row[0];
    $curr_date = $row[1];
    #EMA: {Close - EMA(previous day)} x multiplier + EMA(previous day). 
    $ema_macd = (($curr_macd - $ema_macd_prev) * $ema5const) + $ema_macd_prev;
    $update_ema_macd = "update tickerprice set ema_macd_5 = $ema_macd where ticker_id = $tickid and price_date = '$curr_date'";
 #print "$update_ema_macd\n";
    $ret = $self->{dbh}->do($update_ema_macd) or die "SQL Error: $DBI::errstr\n";
   }
  }
  $sth2->finish();
 }
 $offset--;
 $sth->finish();
}
}

sub getMACD535Offset
{

  my ($self) = shift;
  my ($tickid) = shift;
  my ($pricedate) = shift;
  my ($offset);
  my ($query,$updatedma,$sth,@row,$ret,$avg_price,$ema,$price_date);
  #calculate $offset
  $query = "select max(price_date) from tickerprice where ticker_id = $tickid and price_date <= '$pricedate' and ema_macd_5 is not null";
  $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 $price_date = "2222-12-12";
 while (@row = $sth->fetchrow_array)
 {
      $price_date = $row[0];
 }
  $sth->finish;
  #if (!$row[0]){return -1;}
 $query = " select count(1) from tickerprice where ticker_id = $tickid and price_date > '$price_date' and price_date <= '$pricedate' ";
  $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array)
 {
      $offset = $row[0];
 }
  $sth->finish; 

  #9 day EMA of MACD
  return $offset;   
}
 sub getreccount
{

  my ($self) = shift;
  my ($tickid) = shift;
  my ($query,$noofrecs,$updatedma,$sth,@row,$ret,$avg_price,$ema,$price_date);
  #calculate $noofrecs  
    $query = "select count(*) from tickerprice where ticker_id = $tickid";
      $sth = $self->{dbh}->prepare($query);
       $sth->execute or die "SQL Error: $DBI::errstr\n";
        #print "$query\n";
          while (@row = $sth->fetchrow_array)
           {
                 $noofrecs = $row[0];
          }
      $sth->finish;
    return $noofrecs;
}
sub setStochasticHistory
{
  my ($self) = shift;
  my ($tickid) = shift;
  my ($query,$updatedma,$sth,@row,$ret,$stc,$offset,$flag);
  $flag = 1;
  $offset = 0;
 while ($flag)
{
   $query ="select count(*),max(price_date),max(high_price),min(low_price) from (select price_date,high_price,low_price from tickerprice b where b.ticker_id = $tickid order by price_date asc limit $offset,14) as abc;";
  $sth = $self->{dbh}->prepare($query);
  $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
  while (@row = $sth->fetchrow_array) {
 #print "$row[0]\t$row[1]]\t$row[2]\n";
 if ($self->{dmadays} != $row[0]){$flag = 0;next;}
# %K = 100 X ([Recent Close - Lowest Low (n)] / [Highest High (n) - Lowest low (n)])
 $updatedma = "update tickerprice set stc_osci_14 = 100 * ((close_price - $row[3])/($row[2] - $row[3])) where ticker_id = 

$tickid and price_date = '$row[1]'";
 print "$updatedma\n";
 $ret = $self->{dbh}->do($updatedma);
 }
$sth->finish;
 $offset++;
}

}
1;
