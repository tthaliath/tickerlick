#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath
#Program File: search.pl
#Purpose : Display the search result for the terms entered by user
push(@INC, '/home/tickerlick/cgi-bin');
use lib qw(/home/tickerlick/cgi-bin);
use lib qw(/home/tickerlick/Tickermain);
BEGIN { chdir('/home/tickerlick/cgi-bin'); }
$| = 1;
use strict;
use warnings;
use TickerDB;
use DBI;
use Data::Dumper;
my (@locarr,$location,$querytext,$offset,$catid,$pagetype,$row_count,$l,$keypat,@lindexarr,$res_count,$resulthtml,$result2html,$macdhtml,$charthtml,$framehtml);
my ($size,$nolinks,$sortby,$keycnt,$query_option,$marketcap,$cur,$key);
my ($rep_type,$title,$query,$dbh,$sth,@row,$dividend,$yield,%tickerhash);
my ($pricehistoryhtml) = "";
my ($sql,$ticker,$ticker_id);
require "/home/tickerlick/cgi-bin/gettickerdetall_debug3.pl";
require "/home/tickerlick/cgi-bin/update_sec_fund_data.pl";

$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005')
 or die "Connection Error: $DBI::errstr\n";
$sql = "select ticker_id,ticker from tickermaster where price_flag = 'Y' and ticker_id > 13145 order by ticker_id asc";
$sth = $dbh->prepare($sql);
$sth->execute();
while (@row = $sth->fetchrow_array) {
        $ticker_id = $row[0];
        $ticker = $row[1];
       print "$ticker\t$ticker_id\n";
%tickerhash = getResults($ticker);
if (!$tickerhash{invalidticker})
{
 foreach $key (keys %tickerhash)
  {
     if ($key eq 'DivYield'){next;}
     if (defined $tickerhash{$key} && ($tickerhash{$key} =~ /N\/A/ || $tickerhash{$key} eq '') )
      {
         $tickerhash{$key} = 0;
      }
}
my $tickid = $tickerhash{Ticker};
$tickerhash{Dividend} = 0;
$tickerhash{Yield} = 0;
#print "div:$tickerhash{DivYield}\n";
if (defined $tickerhash{DivYield} && $tickerhash{DivYield} !~ /N\/A/)
{
   ($dividend,$yield) = split(/\(/,$tickerhash{DivYield});
    $dividend =~ s/\s|\)//g;
    $yield =~ s/\s|\)//g;
    $tickerhash{Dividend} = $dividend || 0;
    $tickerhash{Yield} = $yield || 0;
}
if ($tickerhash{class} eq 'ETF')
{
 &updatesecfundmasteretf($ticker_id,\%tickerhash);
}
else
{
  if ($tickerhash{MarketCap} =~ /(.*)([M|B|K])$/)

    {
       $marketcap = $1;
       $cur = $2;
       if ($cur eq 'B')
        {
          $marketcap *= 1000;
        }
       if ($cur eq 'K')
        {
          $marketcap *= 0.001;
        }           
        $tickerhash{MarketCap} = $marketcap;
     }
  &updatesecfundmaster($ticker_id,\%tickerhash);
}
}
}
1;
