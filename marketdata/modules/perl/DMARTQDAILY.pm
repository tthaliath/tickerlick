#!/usr/bin/perl -w
use DBI;
use strict;
use warnings;
package DMARTQDAILY;

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
        price_date => shift,
    };

    bless $self, $class;
    return $self;
}

sub setDMA
{
  my ($self) = shift;
  my ($tickid) = shift;
  my ($offset) = shift;
  my ($query,$updatedma,$sth,@row,$ret);
  while ($offset >= 0)
 {
  
 $query ="SELECT avg(rtq) AS avg_prc, max(seq) as pdate,count(1) as rec_cnt FROM (SELECT rtq, seq FROM tickerrtq7 WHERE ticker_id = $tickid  and price_date >= '$self->{price_date}' ORDER BY seq DESC LIMIT $offset,$self->{dmadays}) AS abc;";
 #print "$query\n";
 $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array) {
 print "$row[0]\t$row[1]\t$row[2]\n";
 if ($self->{dmadays} != $row[2]){next;}
 $updatedma = "update tickerrtq7 set dma_$self->{dmadays} = $row[0] where ticker_id = $tickid and seq = $row[1]";
 #print "$updatedma\n";
 $ret = $self->{dbh}->do($updatedma);
} 
$offset--;
$sth->finish;
}
}

sub setDMASD
{
  my ($self) = shift;
  my ($tickid) = shift;
  my ($offset) = shift;
  my ($query,$updatedma,$sth,@row,$ret);
  while ($offset >= 0)
 {
 #$query = "select SQRT(avg((rtq - dma_10) * (rtq - dma_10))) from tickerrtq7 where ticker_id = 9 and seq > '20141215';
 $query ="SELECT SQRT(avg((rtq - dma_20) * (rtq - dma_20)))  AS dma_20_sd, max(seq) as pdate,count(1) as rec_cnt FROM (SELECT dma_20,rtq, seq FROM tickerrtq7 WHERE ticker_id = $tickid and price_date >= '$self->{price_date}' ORDER BY seq DESC LIMIT $offset,$self->{dmadays}) AS abc;";
 #print "$query\n";
  $sth = $self->{dbh}->prepare($query);
  $sth->execute or die "SQL Error: $DBI::errstr\n";
    #print "$query\n";
     while (@row = $sth->fetchrow_array) {
      #print "$row[0]\t$row[1]]\t$row[2]\n";
       if ($self->{dmadays} != $row[2]){next;}
        $updatedma = "update tickerrtq7 set dma_20_sd = $row[0] where ticker_id = $tickid and seq = $row[1]";
        # print "$updatedma\n";
          $ret = $self->{dbh}->do($updatedma);
       }
       $offset--;
       $sth->finish;
    }
  }


sub getreccount
{

  my ($self) = shift;
  my ($tickid) = shift;
  my ($query,$noofrecs,$updatedma,$sth,@row,$ret,$avg_price,$ema,$seq);
  #calculate $noofrecs
    $query = "select count(*) from tickerrtq7 where ticker_id = $tickid";
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
sub setEMAStart
{
  my ($self) = shift;
  my ($tickid) = shift;
  my ($offset) = shift;
  my ($query,$updatedma,$sth,@row,$ret,$avg_price,$ema);
  
 $query ="SELECT avg(rtq) AS avg_prc, max(seq) as pdate,count(1) as rec_cnt FROM (SELECT rtq, seq FROM tickerrtq7 WHERE ticker_id = $tickid ORDER BY seq DESC LIMIT $offset,$self->{dmadays}) AS abc;";
 $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array) {
 #print "$row[0]\t$row[1]]\t$row[2]\n";
 if ($self->{dmadays} != $row[2]){next;}
 
 $updatedma = "update tickerrtq7 set ema_$self->{dmadays} = $row[0] where ticker_id = $tickid and seq = $row[1]";
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
  my ($query,$updatedma,$sth,$sth2,@row,$ret,$avg_price,$ema,$emaconst,$ema_prev,$update_ema,$curr_price,$curr_seq,$curr_row);
  if ($self->{dmadays} == 35)
 {
    $emaconst = $ema35const;
 }
 elsif ($self->{dmadays} == 5)
 {
    $emaconst = $ema5const;
 }
 else
 {
    return;
 }
  while ($offset > 0)
 {
 $query ="SELECT ema_$self->{dmadays} as ema_prev FROM tickerrtq7 WHERE ticker_id = $tickid ORDER BY seq DESC LIMIT $offset,1;";
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
 if ($self->{dmadays} == 35)
 {
    $emaconst = $ema35const;
 }
 elsif ($self->{dmadays} == 5)
 {
    $emaconst = $ema5const;
 }
 $curr_row = $offset - 1;
 $query ="SELECT rtq,seq FROM tickerrtq7 WHERE ticker_id = $tickid ORDER BY seq DESC LIMIT $curr_row,1;";
 $sth2 = $self->{dbh}->prepare($query);
 $sth2->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth2->fetchrow_array) 
  {
 if ($row[0]){
    $curr_price = $row[0];
    $curr_seq = $row[1];
    #EMA: {Close - EMA(previous day)} x multiplier + EMA(previous day). 
    $ema = (($curr_price - $ema_prev) * $emaconst) + $ema_prev;
    $update_ema = "update tickerrtq7 set ema_$self->{dmadays} = $ema where ticker_id = $tickid and seq = $curr_seq";
    $ret = $self->{dbh}->do($update_ema) or die "SQL Error: $DBI::errstr\n";
   }
  }
  $sth2->finish();
 }
 $offset--;
 $sth->finish();
}
}

sub setEMAMACD535
{
  my ($self) = shift;
  my ($tickid) = shift;
  my ($offset) = shift;
  my ($query,$sth,$sth2,@row,$ret,$avg_price,$ema_macd,$ema_macd_prev,$update_ema_macd,$curr_price,$curr_seq,$curr_row,$curr_macd,$ema_const);
  while ($offset > 0)
 {
 $query ="SELECT ema_macd_5 as ema_macd_prev FROM tickerrtq7 WHERE ticker_id = $tickid ORDER BY seq DESC LIMIT $offset,1;";
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
 $query ="SELECT ema_diff_5_35,seq FROM tickerrtq7 WHERE ticker_id = $tickid ORDER BY seq DESC LIMIT $curr_row,1;";
 #print "$query\n";
 $sth2 = $self->{dbh}->prepare($query);
 $sth2->execute or die "SQL Error: $DBI::errstr\n";
 #print "tom\n";
 while (@row = $sth2->fetchrow_array)
  {
 #print "$row[0]\t$row[1]\n";
 if ($row[1]){
    $curr_macd = $row[0];
    $curr_seq = $row[1];
    #EMA: {Close - EMA(previous day)} x multiplier + EMA(previous day).
    $ema_macd = (($curr_macd - $ema_macd_prev) * $ema5const) + $ema_macd_prev;
    $update_ema_macd = "update tickerrtq7 set ema_macd_5 = $ema_macd where ticker_id = $tickid and seq = $curr_seq";
# print "$update_ema_macd\n";
    $ret = $self->{dbh}->do($update_ema_macd) or die "SQL Error: $DBI::errstr\n";
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
  my ($offset);
  my ($query,$updatedma,$sth,@row,$ret,$avg_price,$ema,$seq);
  #calculate $offset
  $query = "select count(1) as cnt,min(seq) as pdate from tickerrtq7 where ticker_id = $tickid and ema_diff is not null";
  $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array)
 {
      $offset = $row[0];
      $seq = $row[1];
 }
  $sth->finish;
  #9 day EMA of MACD
  $offset = $offset -9;
  if ($offset < 0){
  #print "offset < 0:$tickid\n";
  return;}
 $query ="SELECT avg(ema_diff) AS avg_ema, max(seq) as pdate,count(1) as rec_cnt FROM (SELECT ema_diff, seq FROM tickerrtq7 WHERE ticker_id = $tickid and seq >= '$seq' ORDER BY seq DESC LIMIT $offset,$self->{dmadays}) AS abc;";
 $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array) {
 #print "$row[0]\t$row[1]]\t$row[2]\n";
 if ($self->{dmadays} != $row[2]){next;}
 
 $updatedma = "update tickerrtq7 set ema_macd_9 = $row[0] where ticker_id = $tickid and seq = '$row[1]'";
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
  my ($query,$sth,$sth2,@row,$ret,$avg_price,$ema_macd,$ema_macd_prev,$update_ema_macd,$curr_price,$curr_seq,$curr_row,$curr_macd,$ema_const);
  while ($offset > 0)
 {
 $query ="SELECT ema_macd_9 as ema_macd_prev FROM tickerrtq7 WHERE ticker_id = $tickid ORDER BY seq DESC LIMIT $offset,1;";
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
 $query ="SELECT ema_diff,seq FROM tickerrtq7 WHERE ticker_id = $tickid ORDER BY seq DESC LIMIT $curr_row,1;";
 #print "$query\n";
 $sth2 = $self->{dbh}->prepare($query);
 $sth2->execute or die "SQL Error: $DBI::errstr\n";
 #print "tom\n";
 while (@row = $sth2->fetchrow_array) 
  {
 #print "$row[0]\t$row[1]\n";
 if ($row[0]){
    $curr_macd = $row[0];
    $curr_seq = $row[1];
    #EMA: {Close - EMA(previous day)} x multiplier + EMA(previous day). 
    $ema_macd = (($curr_macd - $ema_macd_prev) * $ema9const) + $ema_macd_prev;
    $update_ema_macd = "update tickerrtq7 set ema_macd_9 = $ema_macd where ticker_id = $tickid and seq = '$curr_seq'";
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
  my ($offset);
  my ($query,$updatedma,$sth,@row,$ret,$avg_price,$ema,$seq);
  #calculate $offset
  $query = "select max(seq) from tickerrtq7 where ticker_id = $tickid and ema_macd_9 is not null";
  $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 $seq = "2222-12-12";
 while (@row = $sth->fetchrow_array)
 {
      $seq = $row[0];
 }
  $sth->finish;
  #if (!$row[0]){return -1;}
 $query = " select count(1) from tickerrtq7 where ticker_id = $tickid and seq > '$seq'";
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

sub getoffset
{

  my ($self) = shift;
  my ($tickid) = shift;
  my ($price_date) = shift;
  my ($offset);
  my ($query,$updatedma,$sth,@row,$ret,$avg_price,$ema,$seq);
  #calculate $offset
  $query = "select count(*) from tickerrtq7 where ticker_id = $tickid and avg_gain is null and price_date >= '$price_date'";
  $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 #$seq = "2222-12-12";
 while (@row = $sth->fetchrow_array)
 {
      $offset = $row[0];
 }
  $sth->finish;
  #if (!$row[0]){return -1;}

  return $offset;
}

sub getseq
{
  my ($self) = shift;
  my ($tickid) = shift;
  my ($offset) = shift;
  my ($query,$updatedma,$sth,@row,$ret,$avg_price,$ema,$seq);
  #calculate $offset
  $query = "select seq from tickerrtq7 where ticker_id = $tickid order by seq desc limit $offset,1";
  $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array)
 {
      $seq = $row[0];
 }
  $sth->finish;

  return $seq;
}

sub setEMAMACD535Start
{
  my ($self) = shift;
  my ($tickid) = shift;
  my ($offset);
  my ($query,$updatedma,$sth,@row,$ret,$avg_price,$ema,$seq);
  #calculate $offset
  $query = "select count(1) as cnt,min(seq) as pdate from tickerrtq7 where ticker_id = $tickid and ema_diff_5_35 is not null";
  $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array)
 {
      $offset = $row[0];
      $seq = $row[1];
 }
  $sth->finish;
  #9 day EMA of MACD
  $offset = $offset -5;
  if ($offset < 0){
  #print "offset < 0:$tickid\n";
  return;}
 $query ="SELECT avg(ema_diff_5_35) AS avg_ema, max(seq) as pdate,count(1) as rec_cnt FROM (SELECT ema_diff_5_35, seq FROM tickerrtq7 WHERE ticker_id = $tickid and seq >= '$seq' ORDER BY seq DESC LIMIT $offset,$self->{dmadays}) AS abc;";
 $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array) {
 #print "$row[0]\t$row[1]]\t$row[2]\n";
 if ($self->{dmadays} != $row[2]){next;}

 $updatedma = "update tickerrtq7 set ema_macd_5 = $row[0] where ticker_id = $tickid and seq = '$row[1]'";
 #print "$updatedma\n";
 $ret = $self->{dbh}->do($updatedma);
 }
$sth->finish;
}

sub setStochasticDaily
{
  my ($self) = shift;
  my ($tickid) = shift;
  my ($query,$updatedma,$sth,@row,$ret,$stc,$offset,$flag);
   $query ="select count(*),max(seq),max(high_price_14),min(low_price_14) from (select seq,high_price_14,low_price_14 from tickerrtq7 b where b.ticker_id = $tickid order by seq desc limit 0,14) as abc;";
  $sth = $self->{dbh}->prepare($query);
  $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
   while (@row = $sth->fetchrow_array) {
    #print "$row[0]\t$row[1]]\t$row[2]\n";
    if ($self->{dmadays} != $row[0]){$flag = 0;last;}
    # %K = 100 X ([Recent Close - Lowest Low (n)] / [Highest High (n) - Lowest low (n)])
      $updatedma = "update tickerrtq7 set stc_osci_14 = 100 * ((rtq - $row[3])/($row[2] - $row[3])) where ticker_id = $tickid and seq = $row[1]";
     #print "$updatedma\n";
      $ret = $self->{dbh}->do($updatedma);
       }
    $sth->finish;
  }
sub getMACD535Offset
{

  my ($self) = shift;
  my ($tickid) = shift;
  my ($offset);
  my ($query,$updatedma,$sth,@row,$ret,$avg_price,$ema,$seq);
 # calculate $offset
  $query = "select max(seq) from tickerrtq7 where ticker_id = $tickid and ema_macd_5 is not null";
  $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
# print "$query\n";
 $seq = 0;
 while (@row = $sth->fetchrow_array)
 {
      $seq = $row[0];
 }
  $sth->finish;
  if (!$seq){return -1;}
 $query = " select count(1) from tickerrtq7 where ticker_id = $tickid and seq > $seq";
  $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
# print "$query\n";
 while (@row = $sth->fetchrow_array)
 {
      $offset = $row[0];
 }
  $sth->finish;

  #9 day EMA of MACD
  return $offset;
}

sub setDMAStochDaily
{
  my ($self) = shift;
  my ($tickid) = shift;
  my ($count,$query,$updatedma,$sth,@row,$ret,@rowcount);
  $query = "SELECT avg(stc_osci_14) AS avg_stc, max(seq) as pdate,count(1) as rec_cnt FROM (SELECT stc_osci_14, seq FROM tickerrtq7 WHERE ticker_id = $tickid ORDER BY seq DESC LIMIT 0,$self->{dmadays}) AS abc;";

 #print "$query\n";
  $sth = $self->{dbh}->prepare($query);
   $sth->execute or die "SQL Error: $DBI::errstr\n";
 #   #print "$query\n";
     while (@row = $sth->fetchrow_array) {
      #print "$row[0]\t$row[1]]\t$row[2]\n";
       if ($self->{dmadays} != $row[2]){next;}
       $updatedma = "update tickerrtq7 set sma_3_stc_osci_14 = $row[0] where ticker_id = $tickid and seq = '$row[1]'";
 #              #print "$updatedma\n";
      $ret = $self->{dbh}->do($updatedma);
       }
       $sth->finish;

 }


sub setDMAStochFullDaily
{
  my ($self) = shift;
  my ($tickid) = shift;
  my ($count,$query,$updatedma,$sth,@row,$ret,@rowcount);
  $query = "SELECT avg(sma_3_stc_osci_14) AS avg_sma_stc, max(seq) as pdate,count(1) as rec_cnt FROM (SELECT sma_3_stc_osci_14, seq from tickerrtq7 WHERE ticker_id = $tickid ORDER BY seq DESC LIMIT 0,$self->{dmadays}) AS abc;";

 #print "$query\n";
   $sth = $self->{dbh}->prepare($query);
      $sth->execute or die "SQL Error: $DBI::errstr\n";
       #   #print "$query\n";
       while (@row = $sth->fetchrow_array) {
               #print "$row[0]\t$row[1]]\t$row[2]\n";
        if ($self->{dmadays} != $row[2]){last;}
            $updatedma = "update tickerrtq7 set sma_3_3_stc_osci_14 = $row[0] where ticker_id = $tickid and seq = '$row[1]'";
             #print "$updatedma\n";
           $ret = $self->{dbh}->do($updatedma);
          }
     $sth->finish;

  }

1;
