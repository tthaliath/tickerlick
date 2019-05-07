#!/usr/bin/perl

use lib qw(/home/tickerlick/cgi-bin);
use LWP::Simple;
use DBI;
use JSON;
use Data::Dumper;

sub getResults
{
my ($ticker) = uc shift;
my (%tickhash) ;
my   $tickdata = "";
my  $tickmain = "";
my   $tickdesc = "";
my $tickprofile = "";
my $url = 'https://query.yahooapis.com/v1/public/yql?q=select%20YearLow,OneyrTargetPrice,DividendShare,ChangeFromFiftydayMovingAverage,FiftydayMovingAverage,PercentChangeFromTwoHundreddayMovingAverage,DaysLow,DividendYield,ChangeFromYearLow,ChangeFromYearHigh,EarningsShare,LastTradePriceOnly,YearHigh,LastTradeDate,PreviousClose,Volume,MarketCapitalization,Name,DividendPayDate,ExDividendDate,PERatio,PercentChangeFromFiftydayMovingAverage,ChangeFromTwoHundreddayMovingAverage,DaysHigh,PercentChangeFromYearLow,TwoHundreddayMovingAverage,PercebtChangeFromYearHigh,Open,Symbol%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22QCOM%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=';

my   $content = get($url);
if ($content)
{
my $obj = from_json($content);
if ($content =~ m/Day\'s Range<\/th><td>N\/A/)
{
 $tickhash{invalidticker} = 1;
 return %tickhash;
}
if ($content =~ /yfi_summary_table type_etf/)
#if (defined $etfhash{$ticker})
#52wk Range:</th><td>N/A</td>
{
 if ($content =~ m/52wk Range.*?<td.*?>N\/A<\/td>/ )
{
$tickmain = getetfmain2(\$content);
}
else
{
 $tickmain = getetfmain1(\$content);
 }
 $content = get("http://in.finance.yahoo.com/q/pr?s=$ticker+Profile");

#die "Couldn't get it!" unless defined $content;

if ($content)
{

$content =~ s/\n//g;
$tickprofile = getetfprofile(\$content);
}
 $tickdata = $ticker."\t".$tickprofile."\t".$tickmain;
 %tickhash =  transformtickerdetetf($tickdata);
 return %tickhash;
}
else
{

#if ($content =~ m/.*?Last Trade.*?<span id.*?>(.*?)<\/span>.*?Trade Time.*?<span id.*?>(.*?)<\/span>.*?1y Target Est.*?td class.*?>(.*?)<\/td>.*?52wk Range.*?td class.*?><span>(.*?)<\/span> \- <span>(.*?)<\/span><\/td>.*?Market Cap\:.*?<td.*?>(.*?)<\/td>.*?P\/E .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?EPS .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?Div.*?Yield.*?td class.*?>(.*?)<\/td>/)  {
#if ($content =~ m/52wk Range.*?<span.*?><\/td>/ )
if ($content =~ m/Volume\:<\/th><td class\=\"yfnc_tabledata1\">N\/A<\/td>/){return "no data";}
if ($content =~ m/52wk Range.*?td class.*?><span>N\/A<\/span>/)
{
$tickmain = getmain2(\$content);
}
else
{
 $tickmain = getmain1(\$content);
 }


 #$content = get("http://finance.yahoo.com/q/pr?s=$ticker+Profile");

#die "Couldn't get it!" unless defined $content;

 #if ($tickmain ne 'NOMARKETCAP')
#{
    #$tickdata = $ticker."\t".$tickprofile."\t".$tickmain."\t".$tickdesc;
     #$tickdata = $ticker."\t".$tickprofile."\t".$tickmain;
     $tickdata = $ticker."\t".$tickmain;
# }
 }
 %tickhash =  transformtickerdet($tickdata);
 return %tickhash;
}
}

 sub getmain1
{
  my $contref = shift;
  my $content = $$contref;
  my($tickmain);
  #print "$content\n";
   #open (C,">aa.txt");
   #print C "$content\n";
   #close (C); 
   #exit;
  my ($mktcapflag) = 1; 
  my ($mktcaptext) = "N/A";
    if ($content =~ m/Market Cap\:.*?<span.*?>N\/A<\/span>/) {$mktcapflag = 0;}
    if ($content =~ m/Market Cap\:.*?<td.*?>N\/A<\/td>/) {$mktcapflag = 0;}
if (!$mktcapflag)
{
  #if ($content =~ m/.*?time_rtq_ticker.*?><span.*?>(.*?)<\/span>.*?Prev Close.*?<td class.*?>(.*?)<\/td>.*?1y Target Est.*?<td class.*?>(.*?)<\/td>.*?52wk Range.*?<span.*?>(.*?)<\/span> - <span>(.*?)<\/span>.*?Volume.*?<span.*?>(.*?)<\/span>.*?P\/E .*?\(ttm\).*?<td class.*?>(.*?)<\/td>.*?EPS .*?\(ttm\).*?<td class.*?>(.*?)<\/td>.*?Div.*?Yield.*?<td class.*?>(.*?)<\/td>/)
if ($content =~ m/.*?Last Trade\:.*?<span.*?>(.*?)<\/span>.*?52wk Range.*?<td.*?>(.*?) - (.*?)<\/td>.*?Volume.*?<span.*?>(.*?)<\/span>.*?Prev Close.*?<td class.*?>(.*?)<\/td>.*?P\/E.*?\(ttm\).*?<td.*?>(.*?)<\/td>.*?EPS.*?\(ttm\).*?<td.*?>(.*?)<\/td>.*?1Y Target Est.*?<td class.*?>(.*?)<\/td>.*?Div.*?Yield.*?<td.*?>(.*?)<\/td>/)
 {
       
      #$tickmain =  $1."\t".$2."\t".$3."-".$4."\t".$5."\t".$6."\t".$7."\t".$8."\t".$9;
      #$tickmain =  $1."\t".$2."\t".$3."\t".$4."-".$5."\t".$6."\t".$mktcaptext."\t".$7."\t".$8."\t".$9; 
      $tickmain =  $1."\t".$5."\t".$8."\t".$2."-".$3."\t".$4."\t".$mktcaptext."\t".$6."\t".$7."\t".$9; 
      $tickmain =~ s/<.*?>//g;
 }
}
else
{
#if ($content =~ m/.*?time_rtq_ticker.*?><span.*?>(.*?)<\/span>.*?Prev Close.*?<td class.*?>(.*?)<\/td>.*?1y Target Est.*?<td class.*?>(.*?)<\/td>.*?52wk Range.*?<span.*?>(.*?)<\/span> - <span>(.*?)<\/span>.*?Volume.*?<span.*?>(.*?)<\/span>.*?Market Cap\:.*?<span.*?>(.*?)<\/span>.*?P\/E .*?\(ttm\).*?<td class.*?>(.*?)<\/td>.*?EPS .*?\(ttm\).*?<td class.*?>(.*?)<\/td>.*?Div.*?Yield.*?<td class.*?>(.*?)<\/td>/)
 if ($content =~ m/.*?Last Trade\:.*?<span.*?>(.*?)<\/span>.*?52wk Range.*?<td.*?>(.*?) - (.*?)<\/td>.*?Volume.*?<span.*?>(.*?)<\/span>.*?Prev Close.*?<td class.*?>(.*?)<\/td>.*?Market Cap\:.*?<span.*?>(.*?)<\/span>.*?P\/E.*?\(ttm\).*?<td.*?>(.*?)<\/td>.*?EPS.*?\(ttm\).*?<td.*?>(.*?)<\/td>.*?1Y Target Est.*?<td class.*?>(.*?)<\/td>.*?Div.*?Yield.*?<td.*?>(.*?)<\/td>/)
 {

      #$tickmain =  $1."\t".$2."\t".$3."\t".$4."-".$5."\t".$6."\t".$7."\t".$8."\t".$9."\t".$10;
       $tickmain =  $1."\t".$5."\t".$9."\t".$2."-".$3."\t".$4."\t".$6."\t".$7."\t".$8."\t".$10;
      $tickmain =~ s/<.*?>//g;
      #print "$tickmain:ddddddddd\n";
 }
}
      return   $tickmain;
}


sub getmain2
{
  my $contref = shift;
  my $content = $$contref;
  my ($tickmain);
  #if ($content =~ m/Market Cap:<\/th><td class\=\"yfnc_tabledata1\">N\/A<\/td>/) {return "NOMARKETCAP";}
#if ($content =~ m/.*?time_rtq_ticker.*?><span.*?>(.*?)<\/span>.*?Prev Close.*?<td class.*?>(.*?)<\/td>.*?1y Target Est.*?<td class.*?>(.*?)<\/td>.*?52wk Range\:<\/th><td class\=\"yfnc_tabledata1\">(.*?)<\/td>.*?Volume.*?<span.*?>(.*?)<\/span>.*?Market Cap\:.*?<span.*?>(.*?)<\/span>.*?P\/E .*?\(ttm\).*?<td class.*?>(.*?)<\/td>.*?EPS .*?\(ttm\).*?<td class.*?>(.*?)<\/td>.*?Div.*?Yield.*?<td class.*?>(.*?)<\/td>/)
 if ($content =~ m/.*?Last Trade\:.*?<span.*?>(.*?)<\/span>.*?52wk Range.*?<td.*?>(.*?)<\/td>.*?Volume.*?<span.*?>(.*?)<\/span>.*?Prev Close.*?<td class.*?>(.*?)<\/td>.*?Market Cap\:.*?<span.*?>(.*?)<\/span>.*?P\/E.*?\(ttm\).*?<td.*?>(.*?)<\/td>.*?EPS.*?\(ttm\).*?<td.*?>(.*?)<\/td>.*?1Y Target Est.*?<td class.*?>(.*?)<\/td>.*?Div.*?Yield.*?<td.*?>(.*?)<\/td>/)
 {

      #$tickmain =  $1."\t".$2."\t".$3."\t".$4."\t".$5."-".$6."\t".$7."\t".$8."\t".$9."\t".$10;
      #$tickmain =  $1."\t".$2."\t".$3."\t".$4."-".$4."\t".$5."\t".$6."\t".$7."\t".$8."\t".$9;
      $tickmain =  $1."\t".$4."\t".$8."\t".$2."-".$2."\t".$3."\t".$5."\t".$6."\t".$7."\t".$9;  
      $tickmain =~ s/<.*?>//g;;

      
      }
      return   $tickmain;
}

sub getprofile
{
  my $contref = shift;
  my $content = $$contref;
  my ($tickprofile);
if ($content =~ m/<title>.*?\|(.*?)Stock.*?Sector:.*?<a href.*?>(.*?)<\/a>.*?Industry:.*?<a href.*?>(.*?)<\/a>/)
{

      $tickprofile =  $1."\t".$2."\t".$3;
      $tickprofile =~ s/\&amp\;/\&/g;

      }
elsif ($content =~ m/<title>.*?\|(.*?)Stock/)
   {
       $tickprofile =  $1."\tN\/A\tN\/A";
   }
else
 {
    $tickprofile =  "N\/A\tN\/A\tN\/A";
 }
      return   $tickprofile;

}

 sub getetfmain1
{
  my $contref = shift;
  my $content = $$contref;
  my($tickmain);
  #.*?NAV\&.*?td class.*?>(.*?)<\/td>.*?52wk Range.*?td class.*?><span>(.*?)<\/span> \- <span>(.*?)<\/span><\/td>.*?Volume.*?<span id.*?>(.*?)<\/span>.*?P\/E .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?Yield.*?td class.*?>(.*?)<\/td>/)
 #if ($content =~ m/time_rtq_ticker.*?<span id.*?>(.*?)<\/span>.*?Prev Close.*?<td class.*?>(.*?)<\/td>.*?NAV.*?td class.*?>(.*?)<\/td>.*?52wk Range.*?td class.*?><span>(.*?)<\/span> \- <span>(.*?)<\/span><\/td>.*?Volume.*?<span id.*?>(.*?)<\/span>.*?P\/E .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?Yield.*?td class.*?>(.*?)<\/td>/)
if ($content =~ m/.*?Last Trade\:.*?<span.*?>(.*?)<\/span>.*?52wk Range\:.*?<td>(.*?) - (.*?)<\/td>.*?Volume\:.*?><span.*?>(.*?)<\/span>.*?Prev Close\:.*?<td.*?>(.*?)<\/td>.*?P\/E \(ttm\)\:.*?<td>(.*?)<\/td>.*?NAV.*?<td.*?>(.*?)<\/td>.*?Yield \(ttm\).*?<td>(.*?)<\/td>/)
  {

      #$tickmain =  $1."\t".$3."\t".$4."\t".$5."\t".$6."\t".$7."\t".$8."\t".$9;
      #$tickmain =  $1."\t".$2."\t".$3."\t".$4."-".$5."\t".$6."\t".$7."\t".$8;
      $tickmain =  $1."\t".$5."\t".$7."\t".$2."-".$3."\t".$4."\t".$6."\t".$8;
      #print   "tickmain1:$tickmain\n";
      $tickmain =~ s/<.*?>//g;
  }
      return   $tickmain;
}


sub getetfmain2
{
  my $contref = shift;
  my $content = $$contref;
  my ($tickmain);
#if ($content =~ m/time_rtq_ticker.*?<span id.*?>(.*?)<\/span>.*?Prev Close.*?<td class.*?>(.*?)<\/td>.*?NAV.*?td class.*?>(.*?)<\/td>.*?52wk Range.*?td class.*?><span>(.*?)<\/span> \- <span>(.*?)<\/span><\/td>.*?Volume.*?<span id.*?>(.*?)<\/span>.*?P\/E .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?Yield.*?td class.*?>(.*?)<\/td>/)
if ($content =~ m/.*?Last Trade\:.*?<span.*?>(.*?)<\/span>.*?52wk Range\:.*?<td>(.*?)<\/td>.*?Volume\:.*?><span.*?>(.*?)<\/span>.*?Prev Close\:.*?<td.*?>(.*?)<\/td>.*?P\/E \(ttm\)\:.*?<td>(.*?)<\/td>.*?NAV.*?<td.*?>(.*?)<\/td>.*?Yield \(ttm\).*?<td>(.*?)<\/td>/)
#if ($content =~ m/time_rtq_ticker.*?<span id.*?>(.*?)<\/span>.*?1y Target Est.*?td class.*?>(.*?)<\/td>/)
{
      #$tickmain =  $1."\t".$2."\t".$3."-".$4."\t".$5."\t".$6."\t".$7;
      #$tickmain =  $1."\t".$2."\t".$3."\t".$4."-".$5."\t".$6."\t".$7."\t".$8;
      $tickmain =  $1."\t".$4."\t".$6."\t".$2."\t".$3."\t".$5."\t".$7;
      $tickmain =~ s/<.*?>//g;
       #print   "tickmain2:$tickmain\n";
 
}
return   $tickmain;
}

sub getetfprofile
{
  my $contref = shift;
  my $content = $$contref;
  my ($tickprofile);
#if ($content =~ m/<title>.*?\|(.*?)Stock.*?Sector:.*?<a href.*?>(.*?)<\/a>.*?Industry:.*?<a href.*?>(.*?)<\/a>/)
#{
     
#      $tickprofile =  $1;
#      }
#elsif ($content =~ m/<title>.*?\|(.*?)Stock/)
#   {
#       $tickprofile =  $1;
#   }
#else
# {
    $tickprofile =  "N\/A";
   
# }
#      $tickprofile =~ s/\&amp\;/\&/g;    
      return   $tickprofile;

}

sub transformtickerdet
{
   my $str = shift;
   my (%tickerhash) = {};
   my ($Ticker,$LastTrade,$PrevClose,$yTargetEst,$wkRange,$vol,$MarketCap,$PE,$EPS,$DivYield,$EnterpriseValue,$TrailingPE,$ForwardPE,$PEGRatio,$PriceSales,$PriceBook,$EnterpriseValueRevenue,$EnterpriseValueEBITDA,$FiscalYearEnds,$MostRecentQuarter,$OperatingMargin,$ReturnonAssets,$ReturnonEquity,$Revenue,$RevenuePerShare,$QtrlyRevenueGrowth,$GrossProfit,$EBITDAttm,$NetIncomeAvltoCommon,$DilutedEPS,$QtrlyEarningsGrowth,$TotalCash,$TotalCashPerShare,$TotalDebt,$TotalDebtEquity,$CurrentRatio,$BookValuePerShare,$OperatingCashFlow,$LeveredFreeCashFlow,$Beta,$WeekChange,$SP50052WeekChange,$WeekHigh,$WeekLow,$fiftyDayMovingAverage,$twohundredDayMovingAverage,$SharesOutstanding,$SharesShort,$PayoutRatio,$exdividenddate);
 my ($Ticker,$LastTrade,$PrevClose,$yTargetEst,$wkRange,$vol,$MarketCap,$PE,$EPS,$DivYield)= split("\t",$str);
    if ($LastTrade == 0) {return null;}
   if ($vol =~ /(.*?)-(.*)/  )
    {
       $vol = $2;
        $wkRange = $wkRange ."-".$1;
    }

   $diff = '';
     $wkRange =~ s/\,//g;
     $LastTrade =~ s/\,//g;
        $wkRange =~ s/\"//g;
     $LastTrade =~ s/\"//g;
   if  ($wkRange =~ /A/)
    {
       $diff = "N\/A";
       $perdiff =    "N\/A";
    }
   elsif (   $wkRange =~ /(.*?)-(.*)/)
   {
       $tickerhash{YearLow} = $1;
       $tickerhash{YearHigh} = $2;
       $diffhigh = $tickerhash{YearHigh} - $LastTrade;
       #$perdiffhigh = abs(($diffhigh/$tickerhash{YearHigh})) * 100;
       $tickerhash{diffhigh} = sprintf("%.2f", $diffhigh);
       #$tickerhash{perdiffhigh} = abs(sprintf("%.2f", $perdiffhigh));
       $difflow = $tickerhash{YearLow} - $LastTrade;
       #$perdifflow = abs(($difflow/$tickerhash{YearLow})) * 100;
       $tickerhash{difflow} = sprintf("%.2f", $difflow);
       #$tickerhash{perdifflow} = abs(sprintf("%.2f", $perdifflow));
       if ($tickerhash{diffhigh} > 0)
       {
        $tickerhash{diffhighstat} = "down";
       }
        else
        {
           $tickerhash{diffhighstat} = "up";     
        }
           
       if ($tickerhash{difflow} > 0)
       {
        $tickerhash{difflowstat} = "down";
       }
        else
        {
           $tickerhash{difflowstat} = "up"; 
        }
   }
$tickerhash{diffhigh} = abs($tickerhash{diffhigh});
$tickerhash{difflow} = abs($tickerhash{difflow});
$tickerhash{PrevClose} = $PrevClose;
#$tickerhash{NetIncomeAvltoCommon} = $NetIncomeAvltoCommon;
#$tickerhash{MostRecentQuarter} = $MostRecentQuarter;
#$tickerhash{TotalDebtEquity} = $TotalDebtEquity;
$tickerhash{wkRange} = $wkRange;
#$tickerhash{TotalCash} = $TotalCash;
#$tickerhash{PEGRatio} = $PEGRatio;
$tickerhash{DivYield} = $DivYield;
#$tickerhash{ReturnonAssets} = $ReturnonAssets;
#$tickerhash{FiscalYearEnds} = $FiscalYearEnds;
#$tickerhash{EnterpriseValueRevenue} = $EnterpriseValueRevenue;
#$tickerhash{GrossProfit} = $GrossProfit;
$tickerhash{Beta} = $Beta;
#$tickerhash{TotalDebt} = $TotalDebt;
#$tickerhash{SharesOutstanding} = $SharesOutstanding;
#$tickerhash{QtrlyRevenueGrowth} = $QtrlyRevenueGrowth;
#$tickerhash{Revenue} = $Revenue;
#$tickerhash{RevenuePerShare} = $RevenuePerShare;
#$tickerhash{name} = $name;
#$tickerhash{sector} = $sector;
#$tickerhash{exdividenddate} = $exdividenddate;
#$tickerhash{WeekLow} = $WeekLow;
#$tickerhash{TotalCashPerShare} = $TotalCashPerShare;
#$tickerhash{PayoutRatio} = $PayoutRatio;
$tickerhash{PE} = $PE;
#$tickerhash{twohundredDayMovingAverage} = $twohundredDayMovingAverage;
#$tickerhash{EnterpriseValueEBITDA} = $EnterpriseValueEBITDA;
#$tickerhash{LeveredFreeCashFlow} = $LeveredFreeCashFlow;
#$tickerhash{WeekHigh} = $WeekHigh;
#$tickerhash{fiftyDayMovingAverage} = $fiftyDayMovingAverage;
#$tickerhash{WeekChange} = $WeekChange;
#$tickerhash{PriceBook} = $PriceBook;
#$tickerhash{OperatingCashFlow} = $OperatingCashFlow;
#$tickerhash{BookValuePerShare} = $BookValuePerShare;
$tickerhash{ForwardPE} = $ForwardPE;
#$tickerhash{OperatingMargin} = $OperatingMargin;
#$tickerhash{DilutedEPS} = $DilutedEPS;
#$tickerhash{ReturnonEquity} = $ReturnonEquity;
$tickerhash{EPS} = $EPS;
#$tickerhash{PriceSales} = $PriceSales;
#$tickerhash{QtrlyEarningsGrowth} = $QtrlyEarningsGrowth;
$tickerhash{yTargetEst} = $yTargetEst;
$tickerhash{vol} = $vol;
$tickerhash{LastTrade} = $LastTrade;
#$tickerhash{SharesShort} = $SharesShort;
#$tickerhash{RevenuePerShare} = $RevenuePerShare;
#$tickerhash{industry} = $industry;
$tickerhash{Ticker} = $Ticker;
$tickerhash{MarketCap} = $MarketCap;
#$tickerhash{CurrentRatio} = $CurrentRatio;
#$tickerhash{EnterpriseValue} = $EnterpriseValue;
#$tickerhash{SP50052WeekChange} = $SP50052WeekChange;
#$tickerhash{TrailingPE} = $TrailingPE;
#$tickerhash{EBITDA} = $EBITDA;
$tickerhash{class} = "Common Stock";
$tickerhash{LastTrade} =~ s/\,//g;
$tickerhash{PrevClose} =~ s/\,//g;
$tickerhash{pricediff} = abs($tickerhash{LastTrade} - $tickerhash{PrevClose});
$tickerhash{pricediff} = sprintf("%.2f", $tickerhash{pricediff});
$tickerhash{pricediffper} = abs(sprintf("%.2f",($tickerhash{pricediff}/$tickerhash{PrevClose}) * 100));
#print "tom:$tickerhash{pricediff},$tickerhash{LastTrade},$tickerhash{PrevClose},$tickerhash{pricediffper}\n";
if ($tickerhash{PrevClose} < $tickerhash{LastTrade})
{
  $tickerhash{PriceStat} = "up";
}
else
{
  $tickerhash{PriceStat} = "down";
}

getlatestdma(\%tickerhash);

return %tickerhash;
}

sub transformtickerdetetf
{
   my $str = shift;
   my (%tickerhash) = {};
   my ($Ticker,$name,$LastTrade,$PrevClose,$Nav,$wkRange,$vol,$PE,$DivYield) = split("\t",$str);
    if ($LastTrade == 0) {next;}
   if ($vol =~ /(.*?)-(.*)/  )
    {
       $vol = $2;
        $wkRange = $wkRange ."-".$1;
    }

   $diff = '';
     $wkRange =~ s/\,//g;
     $LastTrade =~ s/\,//g;
        $wkRange =~ s/\"//g;
     $LastTrade =~ s/\"//g;
   if  ($wkRange =~ /A/)
    {
       $diff = "N\/A";
       $perdiff =    "N\/A";
    }
   elsif (   $wkRange =~ /(.*?)-(.*)/)
   {
       $tickerhash{YearLow} = $1;
       $tickerhash{YearHigh} = $2;
       $diffhigh = $tickerhash{YearHigh} - $LastTrade;
       #$perdiffhigh = abs(($diffhigh/$tickerhash{YearHigh})) * 100;
       $tickerhash{diffhigh} = sprintf("%.2f", $diffhigh);
       #$tickerhash{perdiffhigh} = abs(sprintf("%.2f", $perdiffhigh));
       $difflow = $tickerhash{YearLow} - $LastTrade;
       #$perdifflow = abs(($difflow/$tickerhash{YearLow})) * 100;
       $tickerhash{difflow} = sprintf("%.2f", $difflow);
       #$tickerhash{perdifflow} = abs(sprintf("%.2f", $perdifflow));
       if ($tickerhash{diffhigh} > 0)
       {
        $tickerhash{diffhighstat} = "down";
       }
        else
        {
           $tickerhash{diffhighstat} = "up";
        }

       if ($tickerhash{difflow} > 0)
       {
        $tickerhash{difflowstat} = "down";
       }
        else
        {
           $tickerhash{difflowstat} = "up";
        } 
   }

$tickerhash{diffhigh} = abs($tickerhash{diffhigh});
$tickerhash{difflow} = abs($tickerhash{difflow});
$tickerhash{PrevClose} = $PrevClose;
$tickerhash{wkRange} = $wkRange;
$tickerhash{DivYield} = $DivYield;
$tickerhash{name} = $name;
$tickerhash{PE} = $PE;
$tickerhash{vol} = $vol;
$tickerhash{LastTrade} = $LastTrade;
$tickerhash{Ticker} = $Ticker;
$tickerhash{Nav} = $Nav;
my ($rowlast) = 0;
$tickerhash{class} = "ETF";
$tickerhash{pricediff} = abs($tickerhash{LastTrade} - $tickerhash{PrevClose});
$tickerhash{pricediff} = sprintf("%.2f", $tickerhash{pricediff});
$tickerhash{pricediffper} = abs(sprintf("%.2f",($tickerhash{pricediff}/$tickerhash{PrevClose}) * 100));
#print "tom:$tickerhash{pricediffper}\n";
if ($tickerhash{PrevClose} < $tickerhash{LastTrade})
{
  $tickerhash{PriceStat} = "up";
}
else
{
  $tickerhash{PriceStat} = "down";
}
getlatestdma(\%tickerhash);
return %tickerhash;
}

sub getpricehistory
{
 my $ticker_id = shift;
 my $no_of_days = shift;
 my ($signal,$crossoverlast,$rowhtml,$signal2,@rowhtml2);
 my ($signallast) = 0;
 my ($signallast2) = 0;
 my ($rowprev) = 0;
 my ($rowprev2) = 0;
 my ($rowcount) = 0;
 my ($temphtml) = "";
 my ($signalhtml) = "";
 my ($signalhtml2) = "";
 my ($resulthtml) = "";
 my (@arrdata,@arrcrossover,@arrdata2,@arrcrossover2);
 my (%crossoverhash) = ( 
                         Bullish => Buy,
                         Bearish  => Sell,
                         nochange => '&nbsp;',
                        ); 
my (@row);
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
 $sql ="select a.price_date, a.close_price,ema_diff,ema_macd_9, (ema_diff - ema_macd_9) as signalstrength, ema_diff_5_35,ema_macd_5, (ema_diff_5_35 - ema_macd_5) as signalstrength2,b.rsi_14 as rsi,dma_20,dma_20_sd,(a.close_price - (dma_20 - (2 * dma_20_sd))) as pricebottom, (a.close_price - (dma_20 + (2 * dma_20_sd))) as pricetop,sma_3_3_stc_osci_14  from tickerprice a,  tickerpricersi b, tickermaster c  where a.ticker_id = $ticker_id and c.ticker_id = a.ticker_id and a.ticker_id = b.ticker_id and a.price_date = b.price_date ORDER BY a.price_date DESC LIMIT 0,$no_of_days;";
#$sql = "select a.price_date, a.close_price, (ema_diff - ema_macd_9) as macdmid, (ema_diff_5_35 - ema_macd_5) as macd,b.rsi_14  as rsi, (((dma_20 + (2 * dma_20_sd))) - ((dma_20 -  (2 * dma_20_sd)))) as bollidiff, (a.close_price - (dma_20 - (2 * dma_20_sd))) as pricebottom, (a.close_price - (dma_20 + (2 * dma_20_sd))) as pricetop,sma_3_3_stc_osci_14,ema_diff, ema_macd_9,dma_20,dma_20_sd from tickerprice a, tickerpricersi b, tickermaster c  where a.ticker_id = $ticker_id and c.ticker_id = a.ticker_id and a.ticker_id = b.ticker_id and a.price_date = b.price_date ORDER BY a.price_date DESC LIMIT 0,$no_of_days;";
 $resulthtml  = '<table border="1" cellpadding="1" cellspacing="1" width="70%" align="center" style="border-collapse: collapse;">';
 $resulthtml  .= '<tr bgcolor="#00FFFF"><th colspan=15>Signal and Crossover Data for the last 100 days</th></tr>';
$resulthtml  .= '<tr bgcolor="#00FFFF"><th colspan=2>Price History</th><th colspan=3>MACD Long</th><th colspan=3>MACD Short</th><th colspan=2>RSI</th><th colspan=2>Stochastic</th><th colspan=3>Bollinger</th></tr>';
 $resulthtml .= '<tr bgcolor="#00FFFF"><td>Price Date</td><td>Close Price</td><td>MACD (12,26,9)</td><td>Trend</td><td>Crossover</td><td>MACD (5,35,5)</td><td>Trend</td><td>Crossover</td><td>RSI</td><td>Signal</td><td>Stochastic</td><td>Signal</td><td>Bandwidth</td><td>Volatility</td><td>Signal</td></tr>';
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #select ema_5,ema_35,ema_diff_5_35,ema_macd_5
 undef @row; 
 my ($rcount) = -1;
 $arrcrossover[0] = "<td>$crossoverhash{'nochange'}</td>";
 $arrcrossover2[0] = "<td>$crossoverhash{'nochange'}</td>";

 while (@row = $sth->fetchrow_array)
 {
  $rowcount++;
  $rcount++; 
  #macd(12,26,9)signal
  
 if ($row[2] > $row[3])
{
  $signal = 'Bullish';
   $signalhtml = '<font color="#05840C">Bullish</font>';
}
else
{
  $signal = 'Bearish';
 $signalhtml = '<font color="#FF0000">Bearish</font>';

}
#$row[2] = sprintf("%.3f", $row[2]);
#$row[3] = sprintf("%.3f", $row[3]);
$row[4] = sprintf("%.3f", $row[4]);
$rowhtml = "<tr><td>$row[0]</td><td>$row[1]</td><td>$row[4]</td><td>$signalhtml</td>";

#push (@arrdata, $rowhtml);
$arrdata[$rcount] = $rowhtml;
if (!$signallast)
{
 #print "1:$rowcount,$rowprev,$signallast,$signal\n";
 $signallast = $signal;
 $arrcrossover[$rowcount] = "<td>$crossoverhash{'nochange'}</td>";

}
else
{
if ($signallast ne $signal) #crossover
 {
     $rowprev = $rowcount - 2;
     #print "2:$rowcount,$rowprev,$signallast,$signal\n"; 
     if ($crossoverhash{$signallast} eq 'Buy')
     {
       $arrcrossover[$rowprev] = '<td><b><font color="#05840C">'.$crossoverhash{$signallast}.'</font></b></td>';  
     }
     elsif ($crossoverhash{$signallast} eq 'Sell')
      {
        $arrcrossover[$rowprev] = '<td><b><font color="#FF0000">'.$crossoverhash{$signallast}.'</font></b></td>';
       }
       else
       {
        $arrcrossover[$rowprev] = "<td>$crossoverhash{$signallast}</td>";
       } 
     $arrcrossover[$rowcount - 1] = "<td>$crossoverhash{'nochange'}</td>";
     $signallast = $signal;
 }
  else
  {
    #print "3:$rowcount,$rowprev,$signallast,$signal,$arrcrossover[0]\n";
    $arrcrossover[$rowcount - 1] = "<td>$crossoverhash{'nochange'}</td>";
    if ($rowcount == 2 && $arrcrossover[0] !~ /Buy|Sell/ ) 
    {
        $arrcrossover[0] = "<td>$crossoverhash{'nochange'}</td>";
    }
  }
  
 }
 
 #macd(5,35,5)signal
  
if ($row[5] > $row[6])
{
  $signal2 = 'Bullish';
   $signalhtml2 = '<font color="#05840C">Bullish</font>';
}
else
{
  $signal2 = 'Bearish';
 $signalhtml2 = '<font color="#FF0000">Bearish</font>';

}
#$row[5] = sprintf("%.3f", $row[5]);
#$row[6] = sprintf("%.3f", $row[6]);
$row[7] = sprintf("%.3f", $row[7]);

$rowhtml2 = "<td>$row[7]</td><td>$signalhtml2</td>";


#push (@arrdata2, $rowhtml2);
$arrdata2[$rcount] = $rowhtml2;

if (!$signallast2)
{
 #print "4:$rowcount,$rowprev2,$signallast2,$signal2\n";
 $signallast2 = $signal2;
 $arrcrossover2[$rowcount] = "<td>$crossoverhash{'nochange'}</td>";
 
}
else
{
if ($signallast2 ne $signal2) #crossover
 {
     $rowprev2 = $rowcount - 2;
      #print "5:$rowcount,$rowprev2,$signallast2,$signal2\n";
     
     if ($crossoverhash{$signallast2} eq 'Buy')
     {
       $arrcrossover2[$rowprev2] = '<td><b><font color="#05840C">'.$crossoverhash{$signallast2}.'</font></b></td>';  
     }
     elsif ($crossoverhash{$signallast2} eq 'Sell')
      {
        $arrcrossover2[$rowprev2] = '<td><b><font color="#FF0000">'.$crossoverhash{$signallast2}.'</font></b></td>';
       }
       else
       {
        $arrcrossover2[$rowprev2] = "<td>$crossoverhash{$signallast2}</td>";
       } 
     $arrcrossover2[$rowcount - 1] = "<td>$crossoverhash{'nochange'}</td>";
     $signallast2 = $signal2;
 }
  else
  {
    #print "6:$rowcount,$rowprev2,$signallast2,$signal2\n";
    $arrcrossover2[$rowcount - 1] = "<td>$crossoverhash{'nochange'}</td>";
    if ($rowcount == 2 && $arrcrossover[0] !~ /Buy|Sell/)
    {
        $arrcrossover2[0] = "<td>$crossoverhash{'nochange'}</td>";
    }

  }
  
  }
if ($row[8] < 30)
{
  $signal3= 'Oversold';
   $signalhtml3 = '<font color="#05840C">Oversold</font>';
}
elsif ($row[8] > 70)
{
  $signal3 = 'Overbought';
 $signalhtml3 = '<font color="#FF0000">Overbought</font>';

}
else
{
  $signal3 = '';
 $signalhtml3 = '<font color="#FF0000"></font>';

}
$row[8] = sprintf("%.3f", $row[8]);
$rowhtml3 = "<td>$row[8]</td><td>$signalhtml3</td>";
#$rowhtml3 = "<td>100</td><td>$signalhtml3</td>";
#print "<tr><td>$row[8]</td></tr>";

#push (@arrdata3, $rowhtml3);
$arrdata3[$rcount] = $rowhtml3;
if ($row[13] < 25)
{
  $signal7= 'Oversold';
   $signalhtml7 = '<font color="#05840C">Oversold</font>';
}
elsif ($row[13] > 75)
{
  $signal7 = 'Overbought';
 $signalhtml7 = '<font color="#FF0000">Overbought</font>';

}
else
{
  $signal7 = '';
 $signalhtml7 = '<font color="#FF0000"></font>';

}
$row[13] = sprintf("%.3f", $row[13]);
$rowhtml7 = "<td>$row[13]</td><td>$signalhtml7</td>";
#push (@arrdata7, $rowhtml7);
$arrdata7[$rcount] = $rowhtml7;
if ($row[9] && $row[10])
{
 $dma_20 = sprintf("%.3f", (4*$row[10]/$row[9]));
}
else
{
# set dma_20 to a neutral value
 $dma_20 = 0.17;
}
if  ( $dma_20 <= 0.1)
{
  $signal5= 'Neutral';
   $signalhtml5 = '<font color="#05840C">Low</font>';
}
elsif ($dma_20 >= 0.25)
{
  $signal5 = 'Volatile';
 $signalhtml5 = '<font color="#FF0000">High</font>';

}
else
{
  $signal5 = '';
 $signalhtml5 = '<font color="#FF0000"></font>';

}
$rowhtml5 = "<td>$dma_20</td><td>$signalhtml5</td>";

#push (@arrdata5, $rowhtml5);
$arrdata5[$rcount] = $rowhtml5;

if ($row[11] <= 0)
{
  $signal6= 'Buy';
   $signalhtml6 = '<font color="#05840C">Buy</font>';
}
elsif ($row[11] > 0 && $row[12] < 0 )
{
  $signal6 = 'Hold';
 $signalhtml6 = '<font color="#FF0000"></font>';

}
else
{
  $signal6 = 'Sell';
 $signalhtml6 = '<font color="#FF0000">Sell</font>';

}
$rowhtml6 = "<td>$signalhtml6</td></tr>";

#push (@arrdata6, $rowhtml6);
$arrdata6[$rcount] = $rowhtml6;

}

my $recno = 0;
#$resulthtml = '';
while ($recno < $rowcount)
{
   $resulthtml .=  $arrdata[$recno].$arrcrossover[$recno].$arrdata2[$recno].$arrcrossover2[$recno].$arrdata3[$recno].$arrdata7[$recno].$arrdata5[$recno].$arrdata6[$recno];
   #print "$arrdata[$key].$arrcrossover[$key]\n";
   $recno++;
}
$resulthtml .= "</td></tr></table>";
 $sth->finish;
 $dbh->disconnect; 
  #open (OUT,">/home/tickerlick/cgi-bin/tempres.txt");
  #print OUT $resulthtml;
  #close (OUT);
 return $resulthtml;
}
#get report flags

sub getSignal2
{

 my $ticker_id = shift;
 my (%rephashflag);
 $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
 $sql ="select report_flag from report where ticker_id = $ticker_id and report_flag in ('OS','OB','SS','SB','RS','RB','BBU','BBE')";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array)
 {
     $rephashflag{$row[0]} = $rephash{$row[0]};
 }
 $sth->finish;
 return %rephashflag;
}

      
sub getSignal
{
 my $ticker_id = shift;
 my $no_of_days = shift;
 my ($signallast) = 0;
 my ($signaldate) = 0;
 my(%signalhash);
 #print "GGGGGGGGG\n";
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
 $sql ="select a.price_date, a.close_price,ema_diff,ema_macd_9, (ema_diff - ema_macd_9) as signalstrength, ema_diff_5_35,ema_macd_5, (ema_diff_5_35 - ema_macd_5) as signalstrength2 from tickerprice a where a.ticker_id = $ticker_id ORDER BY a.price_date DESC LIMIT 0,$no_of_days;";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #macd(12,26,9)signal
 while (@row = $sth->fetchrow_array)
 {
  
 #print "1:$row[0]";
 if (!$signallast)
 {
   if ($row[4] > 0)
  {
    $signallast = "Buy";
  }
  else
  {
    $signallast = "Sell";
  }
  $signaldate = $row[0];
 }
elsif ($row[4] <  0 && $signallast eq "Buy") #crossover
 {
  $signalhash{'macd226'}= "$signaldate\t$signallast";
  last;
 }
 elsif ($row[4] >  0 && $signallast eq "Sell") #crossover
 {
  $signalhash{'macd226'}= "$signaldate\t$signallast";
  last;
 }
  elsif ($row[4] > 0)
  {
    $signallast = "Buy";
     $signaldate = $row[0]; 
  }
  else
  {
    $signallast = "Sell";
    $signaldate = $row[0];
  }
}
$sth->finish;
$signallast = 0;
$sth = $dbh->prepare($sql);
$sth->execute or die "SQL Error: $DBI::errstr\n";
#macd(5,35,5)signal
 while (@row = $sth->fetchrow_array)
 {
  
 #print "2:$row[0]";
 if (!$signallast)
 {
   if ($row[7] > 0)
  {
    $signallast = "Buy";
  }
  else
  {
    $signallast = "Sell";
  }
  $signaldate = $row[0];
 }
elsif ($row[7] <  0 && $signallast eq "Buy") #crossover
 {
  $signalhash{'macd535'}= "$signaldate\t$signallast";
  last;
 }
 elsif ($row[7] >  0 && $signallast eq "Sell") #crossover
 {
  $signalhash{'macd535'}= "$signaldate\t$signallast";
  last;
 }
  elsif ($row[7] > 0)
  {
    $signallast = "Buy";
     $signaldate = $row[0]; 
  }
  else
  {
    $signallast = "Sell";
    $signaldate = $row[0];
  }
}
 
 $sth->finish;
 #$dbh->disconnect;
 #print "wwwwww$signalhash{macd226}\n";
 #print "ddddddd$signalhash{macd535}\n";  
 return %signalhash;
}
#get brokerage data
sub getratinghistory
{
 my $ticker_id = shift;
 my (%rephashflag);
 $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
 $sql ="select brokerage_name,rating_date,updown,rating_from,rating_to,price_from,price_to from rating_master where ticker_id = $ticker_id order by rating_date desc limit 10";
 my $resulthtml  = '<table border="1" cellpadding="1" cellspacing="1" width="70%" align="center" style="border-collapse: collapse;">';
 $resulthtml  .= '<tr bgcolor="#00FFFF"><th colspan=12>Analyst Coverage</th></tr>';
 $resulthtml .= '<tr bgcolor="#00FFFF"><td>Brokerage Name</td><td>Date</td><td>Action</td><td>Rating From</td><td>Rating To</td><td>Price From</td><td>Price To</td></tr>';
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array)
 {
     $resulthtml .= "<tr><td>$row[0]</td><td>$row[1]</td><td>$ratinghash{$row[2]}</td><td>$row[3]</td><td>$row[4]</td><td>$row[5]</td><td>$row[6]</td></tr>";
 }
 $sth->finish;
 $resulthtml .= "</table>";
 return $resulthtml;
}

sub getlatestdma
{
 my $tickerhashref = shift;
my ($ticker_id,$flag);
my $lasttrade = $$tickerhashref{LastTrade}; 
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
 $sql = "select ticker_id,comp_name,sector,industry,tflag from tickermaster where ticker = '$$tickerhashref{Ticker}'";
#print "tom1:$sql\n";
  $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
  $ticker_id = $row[0];
  $$tickerhashref{name} = $row[1];
  $$tickerhashref{sector} = $row[2];
  $$tickerhashref{industry} = $row[3];
  $$tickerhashref{tflag} = $row[4];
}
if (!$ticker_id)
{
 $$tickerhashref{dma10} = "N\/A";;
 $$tickerhashref{dma50} = "N\/A";
 $$tickerhashref{dma200} = "N\/A"; 
 next;
}
 $sql ="select dma_10, dma_50, dma_200 from tickerprice a where a.ticker_id = $ticker_id ORDER BY a.price_date DESC LIMIT 0,1;";
#print "tom2:$sql\n";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array)
 {
  $$tickerhashref{dma10} = $row[0] || "N\/A";
  $$tickerhashref{dma50} = $row[1] || "N\/A";
  $$tickerhashref{dma200} = $row[2] || "N\/A";
  $flag = 1;
} 
 $sth->finish;
 #$dbh->disconnect;
 if (!$flag)
{
 $$tickerhashref{dma10} = "N\/A";;
 $$tickerhashref{dma50} = "N\/A";
 $$tickerhashref{dma200} = "N\/A";
}
else
{
 $$tickerhashref{dma10diff} = abs(sprintf("%.2f", $$tickerhashref{dma10} - $lasttrade));
 if ($$tickerhashref{dma10}  && $$tickerhashref{dma10} > 0)
{ 
 $$tickerhashref{dma10diffper} = abs(sprintf("%.2f",($$tickerhashref{dma10diff}/$$tickerhashref{dma10}) * 100));
}
 $$tickerhashref{dma50diff} = abs(sprintf("%.2f", $$tickerhashref{dma50} - $lasttrade));
 if ($$tickerhashref{dma50}  && $$tickerhashref{dma50} > 0)
{
 $$tickerhashref{dma50diffper} = abs(sprintf("%.2f",($$tickerhashref{dma50diff}/$$tickerhashref{dma50}) * 100));
}
 $$tickerhashref{dma200diff} = abs(sprintf("%.2f", $$tickerhashref{dma200} - $lasttrade));
if ($$tickerhashref{dma200} && $$tickerhashref{dma200} > 0)
{
 $$tickerhashref{dma200diffper} = abs(sprintf("%.2f",($$tickerhashref{dma200diff}/$$tickerhashref{dma200}) * 100));
}
 if ($$tickerhashref{dma10} < $lasttrade)
 {
  $$tickerhashref{dma10stat} = "up";
 }
 else
 {
  $$tickerhashref{dma10stat} = "down";
 }
 if ($$tickerhashref{dma50} < $lasttrade)
 {
  $$tickerhashref{dma50stat} = "up";
 }
 else
 {
  $$tickerhashref{dma50stat} = "down";
 }
 if ($$tickerhashref{dma200} < $lasttrade)
 {
  $$tickerhashref{dma200stat} = "up";
 }
 else
 {
  $$tickerhashref{dma200stat} = "down";
 }
}
}
1;
