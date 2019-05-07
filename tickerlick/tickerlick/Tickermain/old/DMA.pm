#!/usr/bin/perl -w
use DBI;
use strict;

package DMA;

our ($ema12const,$ema26const,$ema9const);

$ema26const = 0.074074;
$ema12const = 0.153846;
$ema9const = 0.2;
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
  my ($query,$updatedma,$sth,@row,$ret);
  while ($offset >= 0)
 {
  
 $query ="SELECT avg(close_price) AS avg_prc, max(price_date) as pdate,count(1) as rec_cnt FROM (SELECT close_price, price_date FROM tickerprice WHERE ticker_id = $tickid ORDER BY price_date DESC LIMIT $offset,$self->{dmadays}) AS abc;";
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
  my ($query,$updatedma,$sth,@row,$ret,$avg_price,$ema);
  
 $query ="SELECT avg(close_price) AS avg_prc, max(price_date) as pdate,count(1) as rec_cnt FROM (SELECT close_price, price_date FROM tickerprice WHERE ticker_id = $tickid ORDER BY price_date DESC LIMIT $offset,$self->{dmadays}) AS abc;";
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
  my ($query,$updatedma,$sth,$sth2,@row,$ret,$avg_price,$ema,$emaconst,$ema_prev,$update_ema,$curr_price,$curr_date,$curr_row);
  if ($self->{dmadays} == 26)
 {
    $emaconst = $ema26const;
 }
 elsif ($self->{dmadays} == 12)
 {
    $emaconst = $ema12const;
 }
 else
 {
    return;
 }
  while ($offset > 0)
 {
 $query ="SELECT ema_$self->{dmadays} as ema_prev FROM tickerprice WHERE ticker_id = $tickid ORDER BY price_date DESC LIMIT $offset,1;";
 $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #print "$query\n";
 while (@row = $sth->fetchrow_array)
 {
 #print "$row[0]\t$row[1]]\t$row[2]\n";
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
 $curr_row = $offset - 1;
 $query ="SELECT close_price,price_date FROM tickerprice WHERE ticker_id = $tickid ORDER BY price_date DESC LIMIT $curr_row,1;";
 #print "$query\n";
 $sth2 = $self->{dbh}->prepare($query);
 $sth2->execute or die "SQL Error: $DBI::errstr\n";
 #print "tom\n";
 while (@row = $sth2->fetchrow_array) 
  {
 #print "$row[0]\t$row[1]\n";
 if ($row[0]){
    $curr_price = $row[0];
    $curr_date = $row[1];
    #EMA: {Close - EMA(previous day)} x multiplier + EMA(previous day). 
    $ema = (($curr_price - $ema_prev) * $emaconst) + $ema_prev;
    $update_ema = "update tickerprice set ema_$self->{dmadays} = $ema where ticker_id = $tickid and price_date = '$curr_date'";
 #print "$update_ema\n";
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
  my ($offset);
  my ($query,$updatedma,$sth,@row,$ret,$avg_price,$ema,$price_date);
  #calculate $offset
  $query = "select count(1) as cnt,min(price_date) as pdate from tickerprice where ticker_id = $tickid and ema_diff is not null";
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
 $query ="SELECT avg(ema_diff) AS avg_ema, max(price_date) as pdate,count(1) as rec_cnt FROM (SELECT ema_diff, price_date FROM tickerprice WHERE ticker_id = $tickid and price_date >= '$price_date' ORDER BY price_date DESC LIMIT $offset,$self->{dmadays}) AS abc;";
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
  my ($query,$sth,$sth2,@row,$ret,$avg_price,$ema_macd,$ema_macd_prev,$update_ema_macd,$curr_price,$curr_date,$curr_row,$curr_macd,$ema_const);
  while ($offset > 0)
 {
 $query ="SELECT ema_macd_9 as ema_macd_prev FROM tickerprice WHERE ticker_id = $tickid ORDER BY price_date DESC LIMIT $offset,1;";
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
 $query ="SELECT ema_diff,price_date FROM tickerprice WHERE ticker_id = $tickid ORDER BY price_date DESC LIMIT $curr_row,1;";
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
  my ($offset);
  my ($query,$updatedma,$sth,@row,$ret,$avg_price,$ema,$price_date);
  #calculate $offset
  $query = "select max(price_date) from tickerprice where ticker_id = $tickid and ema_macd_9 is not null";
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
 $query = " select count(1) from tickerprice where ticker_id = $tickid and price_date > '$price_date'";
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
1;

=pod

=head1 SYNOPSIS

    use DMA;
    my $object =DMA->new();
    print $object->as_string;

=head1 DESCRIPTION

This module calculates different trading signals like MACD, RSI, Stochastic and Bollinger Bands from historical stock prices

=head2 Methods

=over 12

=item C<new>

Returns a new DMA object.

=item C<as_string>

Returns a stringified representation of
the object. This is mainly for debugging
purposes.

=back

=head1 AUTHOR

Thomas Thaliath- <http:www.tickerlick.com>

=cut
