#!/usr/bin/perl

use lib qw(/home/tickerlick/cgi-bin);
use LWP::Simple;
use DBI;
use JSON;
use Data::Dumper;
&getResults('yhoo');
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
#my ($str) = {};
#$str->{'PERatio'} = NULL;
my($str) = $obj->{'query'}->{'results'}->{'quote'};
print Dumper($str);
#my %text = decode_json(Dumper($str));
foreach $key (keys %$str)
{
    $str->{$key} =~ s/\+|\%//g;
    if (!$str->{$key}){$str->{$key} = NULL;}
    #print "$str->{$key}\n";
}
print Dumper($str);
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
$str->{'Name'} = "'".$str->{'Name'}."'";
$str->{'Symbol'} = "'".$str->{'Symbol'}."'";
$str->{'LastTradeDate'} = "'".$str->{'LastTradeDate'}."'";
$str->{'DividendPayDate'} = "'".$str->{'DividendPayDate'}."'";
$str->{'ExDividendDate'} = "'".$str->{'ExDividendDate'}."'";
my ($cols) = "YearLow,OneyrTargetPrice,DividendShare,ChangeFromFiftydayMovingAverage,FiftydayMovingAverage,PercentChangeFromTwoHundreddayMovingAverage,DaysLow,DividendYield,ChangeFromYearLow,ChangeFromYearHigh,EarningsShare,LastTradePriceOnly,YearHigh,LastTradeDate,PreviousClose,Volume,MarketCapitalization,Name,DividendPayDate,ExDividendDate,PERatio,PercentChangeFromFiftydayMovingAverage,ChangeFromTwoHundreddayMovingAverage,DaysHigh,PercentChangeFromYearLow,TwoHundreddayMovingAverage,PercebtChangeFromYearHigh,Open,Symbol";
#foreach $key (split /\,/,$cols)
#{
#   if (not defined $str->{$key}){$str{$key} = NULL};
#}
my ($query);
if ($str->{'MarketCapitalization'} && $str->{'DividendShare'})
{
$query = "REPLACE INTO tickerpricefun (YearLow,OneyrTargetPrice,DividendShare,ChangeFromFiftydayMA,DaysLow,FiftydayMA,EarningsShare,LastTradePrice,YearHigh,LastTradeDate,Symbol,PreviousClose,Volume,PERatio,MarketCap,Name,PercentChangeFromTwoHundreddayMA,DividendPayDate,ChangeFromYearHigh,PercentChangeFromFiftydayMA,ChangeFromTwoHundreddayMA,DaysHigh,PercentChangeFromYearLow,PercentChangeFromYearHigh,DividendYield,ChangeFromYearLow,ExDividendDate,TwoHundreddayMA,Open)  values ($str->{'YearLow'},$str->{'OneyrTargetPrice'},$str->{'DividendShare'},$str->{'ChangeFromFiftydayMovingAverage'},$str->{'DaysLow'},$str->{'FiftydayMovingAverage'},$str->{'EarningsShare'},$str->{'LastTradePriceOnly'},$str->{'YearHigh'},$str->{'LastTradeDate'},$str->{'Symbol'},$str->{'PreviousClose'},$str->{'Volume'},$str->{'PERatio'},$str->{'MarketCapitalization'},$str->{'Name'},$str->{'PercentChangeFromTwoHundreddayMovingAverage'},$str->{'DividendPayDate'},$str->{'ChangeFromYearHigh'},$str->{'PercentChangeFromFiftydayMovingAverage'},$str->{'ChangeFromTwoHundreddayMovingAverage'},$str->{'DaysHigh'},$str->{'PercentChangeFromYearLow'},$str->{'PercebtChangeFromYearHigh'},$str->{'DividendYield'},$str->{'ChangeFromYearLow'},$str->{'ExDividendDate'},$str->{'TwoHundreddayMovingAverage'},$str->{'Open'})";
}
else
{
if ($str->{'MarketCapitalization'})
{
$query = "REPLACE INTO tickerpricefun (YearLow,OneyrTargetPrice,ChangeFromFiftydayMA,DaysLow,FiftydayMA,EarningsShare,LastTradePrice,YearHigh,LastTradeDate,Symbol,PreviousClose,Volume,PERatio,MarketCap,Name,PercentChangeFromTwoHundreddayMA,ChangeFromYearHigh,PercentChangeFromFiftydayMA,ChangeFromTwoHundreddayMA,DaysHigh,PercentChangeFromYearLow,PercentChangeFromYearHigh,ChangeFromYearLow,TwoHundreddayMA,Open)  values ($str->{'YearLow'},$str->{'OneyrTargetPrice'},$str->{'ChangeFromFiftydayMovingAverage'},$str->{'DaysLow'},$str->{'FiftydayMovingAverage'},$str->{'EarningsShare'},$str->{'LastTradePriceOnly'},$str->{'YearHigh'},$str->{'LastTradeDate'},$str->{'Symbol'},$str->{'PreviousClose'},$str->{'Volume'},$str->{'PERatio'},$str->{'MarketCapitalization'},$str->{'Name'},$str->{'PercentChangeFromTwoHundreddayMovingAverage'},$str->{'ChangeFromYearHigh'},$str->{'PercentChangeFromFiftydayMovingAverage'},$str->{'ChangeFromTwoHundreddayMovingAverage'},$str->{'DaysHigh'},$str->{'PercentChangeFromYearLow'},$str->{'PercebtChangeFromYearHigh'},$str->{'ChangeFromYearLow'},$str->{'TwoHundreddayMovingAverage'},$str->{'Open'})";
}
else
{
$query = "REPLACE INTO tickerpricefun (YearLow,ChangeFromFiftydayMA,DaysLow,FiftydayMA,EarningsShare,LastTradePrice,YearHigh,LastTradeDate,Symbol,PreviousClose,Volume,Name,PercentChangeFromTwoHundreddayMA,ChangeFromYearHigh,PercentChangeFromFiftydayMA,ChangeFromTwoHundreddayMA,DaysHigh,PercentChangeFromYearLow,PercentChangeFromYearHigh,ChangeFromYearLow,TwoHundreddayMA,Open)  values ($str->{'YearLow'},$str->{'ChangeFromFiftydayMovingAverage'},$str->{'DaysLow'},$str->{'FiftydayMovingAverage'},$str->{'EarningsShare'},$str->{'LastTradePriceOnly'},$str->{'YearHigh'},$str->{'LastTradeDate'},$str->{'Symbol'},$str->{'PreviousClose'},$str->{'Volume'},$str->{'Name'},$str->{'PercentChangeFromTwoHundreddayMovingAverage'},$str->{'ChangeFromYearHigh'},$str->{'PercentChangeFromFiftydayMovingAverage'},$str->{'ChangeFromTwoHundreddayMovingAverage'},$str->{'DaysHigh'},$str->{'PercentChangeFromYearLow'},$str->{'PercebtChangeFromYearHigh'},$str->{'ChangeFromYearLow'},$str->{'TwoHundreddayMovingAverage'},$str->{'Open'})";
}
}
my $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
   print "tom::$query\n";
  my $sth = $dbh->prepare($query);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
}
}
