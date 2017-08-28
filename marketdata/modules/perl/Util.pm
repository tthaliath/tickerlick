#!/usr/bin/perl -w

use lib '/home/tthaliath/Tickermain';
use DBI;
use strict;
use warnings;
package Util;

sub new
{
    my $class = shift;
     my $self = {
        dbh => shift,
    };

    bless $self, $class;
    return $self;
}


sub setMACDTicker
{
  my ($self) = shift;
  my ($tickid) = shift;
  my($updatemacd,$sth,$ret);
 $updatemacd = "update tickerprice set ema_diff = (ema_12 - ema_26) where  ticker_id = $tickid";
 #print "$updatemacd\n";
 $ret = $self->{dbh}->do($updatemacd) or die "SQL Error: $DBI::errstr\n";
}

sub setMACDTicker535
{
  my ($self) = shift;
  my ($tickid) = shift;
  my($updatemacd,$sth,$ret);
 $updatemacd = "update tickerprice set ema_diff_5_35 = (ema_5 - ema_35) where  ticker_id = $tickid";
 #print "$updatemacd\n";
 $ret = $self->{dbh}->do($updatemacd) or die "SQL Error: $DBI::errstr\n";
}

sub setMACDTickerDate
{
  my ($self) = shift;
  my ($tickid) = shift;
  my ($price_date) = shift;
  my($updatemacd,$sth,$ret);
 $updatemacd = "update tickerprice set ema_diff = (ema_12 - ema_26) where  ticker_id = $tickid and price_date = '$price_date'";
 #print "$updatemacd\n";
 $ret = $self->{dbh}->do($updatemacd) or die "SQL Error: $DBI::errstr\n";
 }

sub setMACDTickerDate535
{
  my ($self) = shift;
  my ($tickid) = shift;
  my ($price_date) = shift;
  my($updatemacd,$sth,$ret);
 $updatemacd = "update tickerprice set ema_diff_5_35 = (ema_5 - ema_35) where  ticker_id = $tickid and price_date = '$price_date'";
 #print "$updatemacd\n";
 $ret = $self->{dbh}->do($updatemacd) or die "SQL Error: $DBI::errstr\n";
}

 
1;
