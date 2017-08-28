#!/usr/bin/perl -w

use lib '/home/tthaliath/Tickermain';
use DBI;
use strict;
use warnings;
package TickerDB;

sub new
{
    my $class = shift;
     my $self = {
        price_date => shift,
        dbh => shift,
    };

    bless $self, $class;
    return $self;
}

sub loadPrice
{
  my ($self) = shift;
  my ($ticker_id) = shift;
  my ($price_date) = shift;
  my ($last_price) = shift;
  my ($deletesql,$insertsql,$sth,@row,$ret);
  #if price exists for given date. if exists, delete it first.
  $deletesql = "delete from tickerprice where ticker_id = $ticker_id and price_date = '$self->{price_date}'";
 $ret = $self->{dbh}->do($deletesql);
 $insertsql = "insert into tickerprice (ticker_id,price_date,close_price) values ($ticker_id,'$self->{price_date}',$last_price)";
 $ret = $self->{dbh}->do($insertsql);
}

sub getTickerIDMax
{

  my ($self) = shift;
  my ($query,$sth,@row,$ret,$tickeridmax);
  #calculate $offset
  $query = "select max(ticker_id) from tickerprice where price_date = '$self->{price_date}'";
 #print "$query\n";
  $sth = $self->{dbh}->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array)
 {
      $tickeridmax = $row[0];
 }
  $sth->finish;
  return $tickeridmax;   
}

sub setMACDSingle
{
  my ($self) = shift;
  my ($tickid) = shift;
  my ($price_date) = shift;
  my($updatemacd,$sth,$ret);
 $updatemacd = "update tickerprice set ema_diff = (ema_12 - ema_26) where  ticker_id = $tickid and price_date = '$price_date'";
 #print "$updatemacd\n";
 $ret = $self->{dbh}->do($updatemacd) or die "SQL Error: $DBI::errstr\n";
}

sub setMACD_5355
{
  my ($self) = shift;
  my ($tickidmin) = shift;
  my ($tickidmax) = shift;
  my($updatemacd,$sth,$ret);
 $updatemacd = "update tickerprice set ema_diff_5_35 = (ema_5 - ema_35) where ticker_id >= $tickidmin and ticker_id <= $tickidmax and  price_date = '$self->{price_date}'";
 print "$updatemacd\n";
  $ret = $self->{dbh}->do($updatemacd) or die "SQL Error: $DBI::errstr\n";
  }

sub setMACD_12269
{
  my ($self) = shift;
  my ($tickidmin) = shift;
  my ($tickidmax) = shift;
  my($updatemacd,$sth,$ret);
 $updatemacd = "update tickerprice set ema_diff = (ema_12 - ema_26) where ticker_id >= $tickidmin and ticker_id <= $tickidmax and  price_date = '$self->{price_date}'";
# print "$updatemacd\n";
  $ret = $self->{dbh}->do($updatemacd) or die "SQL Error: $DBI::errstr\n";
  }

1;
