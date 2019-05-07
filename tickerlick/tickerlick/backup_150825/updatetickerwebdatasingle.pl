#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath
#Program File: search.pl
#Date started : 06/24/03
#Last Modified : 11/07/03
#Purpose : Display the search result for the terms entered by user
use lib qw(/home/tickerlick/cgi-bin);
use lib qw(/home/tickerlick/Tickermain);
BEGIN { chdir('/home/tickerlick/cgi-bin'); }
$| = 1;
use strict;
use CGI;
use TickerDB;
use UpdateTickerPriceData;
use TickerWeb;
#use TickerWeb1;
use Date::Calc qw(Day_of_Week);
my ($q) = new CGI;
my ($getprice) = new TickerWeb;
#my ($addprice) = new UpdateTickerPriceData;
my (@locarr,$location,$querytext,$offset,$catid,$pagetype,$row_count,$l,$keypat,@lindexarr,$res_count,$resulthtml,$result2html,$macdhtml,$charthtml,$framehtml);
my ($size,$nolinks,$sortby,$keycnt,$query_option,%keyhash);
my ($rep_type,$title,$query,$dbh,$sth,@row,$key,$ticker_id,$ticker);
#use ISTR::Search;
#my ($SEARCH) = ISTR::Search->new();
#require "gettickerdet.pl";
#require "updatetickerpricedata_new.pl";
#print header;
#get all the form variable values
#my (@locarr) = $q->param("l");
#foreach (@locarr){print "location:$_<br>";}
#$querytext = $ARGV[0];
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
$query = "select ticker_id,ticker from tickermaster where ticker_id = 780 order by ticker_id asc";
$sth = $dbh->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array)
 {
    $ticker_id = $row[0];
    $ticker = $row[1]; 
   print "$ticker_id: $ticker\n";
my %tickerhash = $getprice->getResults($ticker);
if ($tickerhash{invalidticker})
{
   print "invalid:$tickerhash{invalidticker}\n";
}
elsif ($tickerhash{Ticker})
{
   foreach $key (keys %tickerhash)
   {
   if ($key ne 'Ticker' && $tickerhash{$key} ne 'NULL')
  {
    $tickerhash{$key} = "'".$tickerhash{$key}."'";
    #print "$key:$tickerhash{$key}\n";
   }
  }
  #print "ticker:$tickerhash{Ticker}\n";
  my $sql = "replace into secmaster(ticker_id,pegratio,operatingcashflow,sharesoutstanding,divyield,wkrange,mostrecentquarter,dma10diffper,qtrlyrevenuegrowth,marketcap,weekchange,prevclose,dma50diffper,difflowstat,fiscalyearends,lasttrade,payoutratio,enterprisevalueebitda,dma50stat,grossprofit,perdifflow,trailingpe,enterprisevalue,dma200,totalcashpershare,operatingmargin,pricesales,pricestat,diffhighstat,revenuepershare,pricediffper,beta,weeklow,dma10stat,netincomeavltocommon,sharesshort,pe,qtrlyearningsgrowth,enterprisevaluerevenue,pricebook,sp50052weekchange,totaldebtequity,dma200stat,nav,dma50diff,returnonassets,dilutedeps,pricediff,revenue,exdividenddate,returnonequity,dma10diff,difflow,totaldebt,class,leveredfreecashflow,yearlow,dma200diffper,weekhigh,dma10,forwardpe,dma50,dma200diff,ytargetest,ebitda,yearhigh,twohundreddaymovingaverage,currentratio,eps,diffhigh,bookvaluepershare,perdiffhigh,fiftydaymovingaverage,totalcash) values ($ticker_id,$tickerhash{PEGRatio},$tickerhash{OperatingCashFlow},$tickerhash{SharesOutstanding},$tickerhash{DivYield},$tickerhash{wkRange},$tickerhash{MostRecentQuarter},$tickerhash{dma10diffper},$tickerhash{QtrlyRevenueGrowth},$tickerhash{MarketCap},$tickerhash{WeekChange},$tickerhash{PrevClose},$tickerhash{dma50diffper},$tickerhash{difflowstat},$tickerhash{FiscalYearEnds},$tickerhash{LastTrade},$tickerhash{PayoutRatio},$tickerhash{EnterpriseValueEBITDA},$tickerhash{dma50stat},$tickerhash{GrossProfit},$tickerhash{perdifflow},$tickerhash{TrailingPE},$tickerhash{EnterpriseValue},$tickerhash{dma200},$tickerhash{TotalCashPerShare},$tickerhash{OperatingMargin},$tickerhash{PriceSales},$tickerhash{PriceStat},$tickerhash{diffhighstat},$tickerhash{RevenuePerShare},$tickerhash{pricediffper},$tickerhash{Beta},$tickerhash{WeekLow},$tickerhash{dma10stat},$tickerhash{NetIncomeAvltoCommon},$tickerhash{SharesShort},$tickerhash{PE},$tickerhash{QtrlyEarningsGrowth},$tickerhash{EnterpriseValueRevenue},$tickerhash{PriceBook},$tickerhash{SP50052WeekChange},$tickerhash{TotalDebtEquity},$tickerhash{dma200stat},$tickerhash{Nav},$tickerhash{dma50diff},$tickerhash{ReturnonAssets},$tickerhash{DilutedEPS},$tickerhash{pricediff},$tickerhash{Revenue},$tickerhash{exdividenddate},$tickerhash{ReturnonEquity},$tickerhash{dma10diff},$tickerhash{difflow},$tickerhash{TotalDebt},$tickerhash{class},$tickerhash{LeveredFreeCashFlow},$tickerhash{YearLow},$tickerhash{dma200diffper},$tickerhash{WeekHigh},$tickerhash{dma10},$tickerhash{ForwardPE},$tickerhash{dma50},$tickerhash{dma200diff},$tickerhash{yTargetEst},$tickerhash{EBITDA},$tickerhash{YearHigh},$tickerhash{twohundredDayMovingAverage},$tickerhash{CurrentRatio},$tickerhash{EPS},$tickerhash{diffhigh},$tickerhash{BookValuePerShare},$tickerhash{perdiffhigh},$tickerhash{fiftyDayMovingAverage},$tickerhash{TotalCash})";
#print "$sql\n";
 my $ret = $dbh->do($sql) or die "SQL Error: $DBI::errstr\n";
}
}

$sth->finish();
$dbh->disconnect;
