#!/usr/bin/perl

use lib qw(/home/tickerlick/cgi-bin);
use LWP::Simple;
use DBI;
use JSON;
use Data::Dumper;
my ($dbh,$sth,$sth1);
my $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
$sql = "select ticker from tickermaster where price_flag = 'Y'";
$sth = $dbh->prepare($sql);
$sth->execute();
while (@row = $sth->fetchrow_array) {

 &getResults($row[0]);
}
$sth->finish;
$dbh->disconnect;

sub getResults
{
my ($ticker) = uc shift;
my (%tickhash) ;
my $url = 'https://query.yahooapis.com/v1/public/yql?q=select%20YearLow,OneyrTargetPrice,DividendShare,ChangeFromFiftydayMovingAverage,FiftydayMovingAverage,PercentChangeFromTwoHundreddayMovingAverage,DaysLow,DividendYield,ChangeFromYearLow,ChangeFromYearHigh,EarningsShare,LastTradePriceOnly,YearHigh,LastTradeDate,PreviousClose,Volume,MarketCapitalization,Name,DividendPayDate,ExDividendDate,PERatio,PercentChangeFromFiftydayMovingAverage,ChangeFromTwoHundreddayMovingAverage,DaysHigh,PercentChangeFromYearLow,TwoHundreddayMovingAverage,PercebtChangeFromYearHigh,Open,Symbol%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22'.$ticker.'%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=';

my   $content = get($url);
if ($content)
{
my $obj = from_json($content);
if ($content =~ m/Day\'s Range<\/th><td>N\/A/)
{
 $tickhash{invalidticker} = 1;
 return %tickhash;
}
my($str) = $obj->{'query'}->{'results'}->{'quote'};
#print Dumper($str);
#my %text = decode_json(Dumper($str));
if ($str->{'Name'} &&$str->{'LastTradePriceOnly'})
{
foreach $key (keys %$str)
{
    $str->{$key} =~ s/\+|\%//g;
    if (!$str->{$key}){$str->{$key} = NULL;}
}
#print Dumper($str);
if ($str->{'MarketCapitalization'} =~ /(.*)B$/)
{
    $str->{'MarketCapitalization'} = $1 * 1000;
}
elsif ($str->{'MarketCapitalization'} =~ /(.*)K$/)
{
    $str->{'MarketCapitalization'} = $1 *0.001;
}
elsif ($str->{'MarketCapitalization'} =~ /(.*)M$/)
{
    $str->{'MarketCapitalization'} = $1;
}
($m,$d,$y) = split (/\//,$str->{'LastTradeDate'});
if ($m > 0)
{
$str->{'LastTradeDate'} = $y."-".$m."-".$d;
}
($m,$d,$y) = split (/\//,$str->{'DividendPayDate'});
if ($m > 0)
{
$str->{'DividendPayDate'} = $y."-".$m."-".$d;
}
($m,$d,$y) = split (/\//,$str->{'ExDividendDate'});
if ($m > 0)
{
$str->{'ExDividendDate'} = $y."-".$m."-".$d;
}
$str->{'Name'} =~ s/\'|\"//g;
$str->{'Name'} = "'".$str->{'Name'}."'";
$str->{'Symbol'} = "'".$str->{'Symbol'}."'";
$str->{'LastTradeDate'} = "'".$str->{'LastTradeDate'}."'";
$str->{'DividendPayDate'} = "'".$str->{'DividendPayDate'}."'";
$str->{'ExDividendDate'} = "'".$str->{'ExDividendDate'}."'";
#my ($cols) = "YearLow,OneyrTargetPrice,DividendShare,ChangeFromFiftydayMovingAverage,FiftydayMovingAverage,PercentChangeFromTwoHundreddayMovingAverage,DaysLow,DividendYield,ChangeFromYearLow,ChangeFromYearHigh,EarningsShare,LastTradePriceOnly,YearHigh,LastTradeDate,PreviousClose,Volume,MarketCapitalization,Name,DividendPayDate,ExDividendDate,PERatio,PercentChangeFromFiftydayMovingAverage,ChangeFromTwoHundreddayMovingAverage,DaysHigh,PercentChangeFromYearLow,TwoHundreddayMovingAverage,PercebtChangeFromYearHigh,Open,Symbol";
my ($query);
$query = "REPLACE INTO tickerpricefun (YearLow,OneyrTargetPrice,DividendShare,ChangeFromFiftydayMA,DaysLow,FiftydayMA,EarningsShare,LastTradePrice,YearHigh,LastTradeDate,Symbol,PreviousClose,Volume,PERatio,MarketCap,Name,PercentChangeFromTwoHundreddayMA,DividendPayDate,ChangeFromYearHigh,PercentChangeFromFiftydayMA,ChangeFromTwoHundreddayMA,DaysHigh,PercentChangeFromYearLow,PercentChangeFromYearHigh,DividendYield,ChangeFromYearLow,ExDividendDate,TwoHundreddayMA,Open)  values ($str->{'YearLow'},$str->{'OneyrTargetPrice'},$str->{'DividendShare'},$str->{'ChangeFromFiftydayMovingAverage'},$str->{'DaysLow'},$str->{'FiftydayMovingAverage'},$str->{'EarningsShare'},$str->{'LastTradePriceOnly'},$str->{'YearHigh'},$str->{'LastTradeDate'},$str->{'Symbol'},$str->{'PreviousClose'},$str->{'Volume'},$str->{'PERatio'},$str->{'MarketCapitalization'},$str->{'Name'},$str->{'PercentChangeFromTwoHundreddayMovingAverage'},$str->{'DividendPayDate'},$str->{'ChangeFromYearHigh'},$str->{'PercentChangeFromFiftydayMovingAverage'},$str->{'ChangeFromTwoHundreddayMovingAverage'},$str->{'DaysHigh'},$str->{'PercentChangeFromYearLow'},$str->{'PercebtChangeFromYearHigh'},$str->{'DividendYield'},$str->{'ChangeFromYearLow'},$str->{'ExDividendDate'},$str->{'TwoHundreddayMovingAverage'},$str->{'Open'})";
   print "tom::$query\n";
 $sth1 = $dbh->prepare($query);
 $sth1->execute or die "SQL Error: $DBI::errstr\n";
 $sth1->finish;
}
}
}
