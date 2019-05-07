#!/usr/bin/perl

use lib qw(/home/tickerlick/Tickermain);
use LWP::Simple;
use DBI;
use Date::Calc qw(Day_of_Week);
my ($ticker,%tickerhash,$ret,@rest,$ticker_id,$last_price) ;

sub updatesecfundmaster
{
$ticker_id = shift;
$tickerhash = shift;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
 #insert into tickerpricersi
 my $insertsql = "replace into sec_fund_master (  ticker_id,  prevclose,  dividend ,   yield,  yearlow,  yearhigh,  pe,  dma10,  dma200,  dma50,  eps,  ytargetest,  lasttrade,  marketcap,  dma50diff,  dma10diff,  dma200diff) values ($ticker_id,$tickerhash->{PrevClose},$tickerhash->{Dividend},$tickerhash->{Yield},$tickerhash->{YearLow},$tickerhash->{YearHigh},$tickerhash->{PE},$tickerhash->{dma10},$tickerhash->{dma200},$tickerhash->{dma50},$tickerhash->{EPS},$tickerhash->{yTargetEst},$tickerhash->{LastTrade},$tickerhash->{MarketCap},$tickerhash->{dma50diff},$tickerhash->{dma10diff},$tickerhash->{dma200diff})";
#print "$insertsql\n";
 $ret = $dbh->do($insertsql);
}

sub updatesecfundmasteretf
{
$ticker_id = shift;
$tickerhash = shift;
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
 #insert into tickerpricersi
 my $insertsql = "replace into sec_fund_master (  ticker_id,  prevclose, yearlow,  yearhigh,  dma10,  dma200,  dma50,  lasttrade,  dma50diff,  dma10diff,  dma200diff,nav) values ($ticker_id,$tickerhash->{PrevClose},$tickerhash->{YearLow},$tickerhash->{YearHigh},$tickerhash->{dma10},$tickerhash->{dma200},$tickerhash->{dma50},$tickerhash->{LastTrade},$tickerhash->{dma50diff},$tickerhash->{dma10diff},$tickerhash->{dma200diff},$tickerhash->{Nav})";
 $ret = $dbh->do($insertsql);
}
1;
