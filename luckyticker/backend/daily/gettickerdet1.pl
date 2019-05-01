#!/usr/bin/perl

use lib qw(/home/tickerlick/cgi-bin);
use LWP::Simple;
sub getResults
{
my ($ticker) = lc shift;
my (%tickhash) ;
   $tickdata = "";
   $tickmain = "";
   $tickdesc = "";
  $content = get("http://finance.yahoo.com/q?s=$ticker");

if ($content)
{

$content =~ s/\n//g;
#print "$content\n";
#if ($content =~ /<a href\=\"\/etf\">ETFs<\/a>/)
#{
# print "etf1:$ticker\n";
#open (ETF, ">>etf.csv");
#print   ETF "$ticker\n";
#close (ETF);
#next;
#}
#if ($content =~ m/.*?time_rtq_ticker\"><.*?>(.*?)<\/span>1y Target Est.*?td class.*?>(.*?)<\/td>.*?52wk Range.*?td class.*?><span>(.*?)<\/span> \- <span>(.*?)<\/span><\/td>.*?Market Cap\:.*?<span id.*?>(.*?)<\/span>.*?P\/E .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?EPS .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?Div.*?Yield.*?td class.*?>(.*?)<\/td>/i)  {
if ($content =~ /\>NAV\&|iShares|SPDR|Market Vectors|\sETN\s|Direxion|ProShare|EGShares|Guggenheim|PowerShares|Global\sX|Sprott|Cambria|PIMCO|QuantShares|DBX\s|\sETF\s\($ticker\)|AlphaDEX|FactorShares|FlexShares/)
{
return "ETF";
}




#if ($content =~ m/.*?Last Trade.*?<span id.*?>(.*?)<\/span>.*?Trade Time.*?<span id.*?>(.*?)<\/span>.*?1y Target Est.*?td class.*?>(.*?)<\/td>.*?52wk Range.*?td class.*?><span>(.*?)<\/span> \- <span>(.*?)<\/span><\/td>.*?Market Cap\:.*?<td.*?>(.*?)<\/td>.*?P\/E .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?EPS .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?Div.*?Yield.*?td class.*?>(.*?)<\/td>/)  {
#print "ddd:$ticker\n";
#if ($content =~ m/52wk Range.*?<span.*?><\/td>/ )
if ($content =~ m/Volume\:<\/th><td class\=\"yfnc_tabledata1\">N\/A<\/td>/){return "no data";}
if ($content =~ m/52wk Range\:<\/th><td class\=\"yfnc_tabledata1\">N\/A<\/td>/)
{
$tickmain = getmain2(\$content);
}
else
{
 $tickmain = getmain1(\$content);
 }


 $content = get("http://finance.yahoo.com/q/pr?s=$ticker+Profile");

#die "Couldn't get it!" unless defined $content;

my ($tickprofile);
if ($content)
{

$content =~ s/\n//g;
$tickprofile = getprofile(\$content);
}
  $content = get("http://finance.yahoo.com/q/ks?s=$ticker+Key+Statistics");
  if ($content)
  {
  $content =~ s/\n//g;
 if ($content =~ m/Market Cap \(intraday\).*?<span id.*?>(.*?)<\/span>.*?Enterprise Value.*?td class.*?>(.*?)<\/td>.*?Trailing P\/E.*?td class.*?>(.*?)<\/td>.*?Forward P\/E.*?td class.*?>(.*?)<\/td>.*?PEG Ratio.*?td class.*?>(.*?)<\/td>.*?Price\/Sales.*?td class.*?>(.*?)<\/td>.*?Price\/Book.*?td class.*?>(.*?)<\/td>.*?Enterprise Value\/Revenue.*?td class.*?>(.*?)<\/td>.*?Enterprise Value\/EBITDA.*?td class.*?>(.*?)<\/td>.*?Fiscal Year Ends.*?td class.*?>(.*?)<\/td>.*?Most Recent Quarter.*?td class.*?>(.*?)<\/td>.*?Operating Margin.*?td class.*?>(.*?)<\/td>.*?Return on Assets.*?td class.*?>(.*?)<\/td>.*?Return on Equity.*?td class.*?>(.*?)<\/td>.*?Revenue.*?td class.*?>(.*?)<\/td>.*?Revenue Per Share.*?td class.*?>(.*?)<\/td>.*?Qtrly Revenue Growt.*?td class.*?>(.*?)<\/td>.*?Gross Profit.*?td class.*?>(.*?)<\/td>.*?EBITDA \(ttm\).*?td class.*?>(.*?)<\/td>.*?Net Income Avl to Common.*?td class.*?>(.*?)<\/td>.*?Diluted EPS.*?td class.*?>(.*?)<\/td>.*?Qtrly Earnings Growth.*?td class.*?>(.*?)<\/td>.*?Total Cash.*?td class.*?>(.*?)<\/td>.*?Total Cash Per Share.*?td class.*?>(.*?)<\/td>.*?Total Debt.*?td class.*?>(.*?)<\/td>.*?Total Debt\/Equity.*?td class.*?>(.*?)<\/td>.*?Current Ratio.*?td class.*?>(.*?)<\/td>.*?Book Value Per Share.*?td class.*?>(.*?)<\/td>.*?Operating Cash Flow.*?td class.*?>(.*?)<\/td>.*?Levered Free Cash Flow.*?td class.*?>(.*?)<\/td>.*?Beta\:.*?td class.*?>(.*?)<\/td>.*?52\-Week Change.*?td class.*?>(.*?)<\/td>.*?S.*?P500 52\-Week Change.*?td class.*?>(.*?)<\/td>.*?52\-Week High.*?td class.*?>(.*?)<\/td>.*?52\-Week Low.*?td class.*?>(.*?)<\/td>.*?50\-Day Moving Average.*?td class.*?>(.*?)<\/td>.*?200\-Day Moving Average.*?td class.*?>(.*?)<\/td>.*?Shares Outstanding.*?td class.*?>(.*?)<\/td>.*?Shares Short.*?\).*?td class.*?>(.*?)<\/td>.*?Payout Ratio.*?td class.*?>(.*?)<\/td>.*?Ex\-Dividend Date.*?<td.*?>(.*?)<\/td>/i){
         $tickdesc = $2."\t".$3."\t".$4."\t".$5."\t".$6."\t".$7."\t".$8."\t".$9."\t".$10."\t".$11."\t".$12."\t".$13."\t".$14."\t".$15."\t".$16."\t".$17."\t".$18."\t".$19."\t".$20."\t".$21."\t".$22."\t".$23."\t".$24."\t".$25."\t".$26."\t".$27."\t".$28."\t".$29."\t".$30."\t".$31."\t".$32."\t".$33."\t".$34."\t".$35."\t".$36."\t".$37."\t".$38."\t".$39."\t".$40."\t".$41;
         }
   else
 {
     print "undefined det2:$ticker\n";
 }
 }
 else
 {
     print "undefined det1:$ticker\n";
 }

 if ($tickmain ne 'NOMARKETCAP')
{
    $tickdata = $ticker."\t".$tickprofile."\t".$tickmain."\t".$tickdesc;
 }
 }
 %tickhash =  transformtickerdet($tickdata);
 return %tickhash;
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
   
    if ($content =~ m/Market Cap:<\/th><td class\=\"yfnc_tabledata1\">N\/A<\/td>/) {print "NOMARKETCAP\n";return "NOMARKETCAP";}
if ($content =~ m/.*?time_rtq_ticker.*?><span.*?>(.*?)<\/span>.*?1y Target Est.*?<td class.*?>(.*?)<\/td>.*?52wk Range.*?<span.*?>(.*?)<\/span> - <span>(.*?)<\/span>.*?Volume.*?<span.*?>(.*?)<\/span>.*?Market Cap\:.*?<span.*?>(.*?)<\/span>.*?P\/E .*?\(ttm\).*?<td class.*?>(.*?)<\/td>.*?EPS .*?\(ttm\).*?<td class.*?>(.*?)<\/td>.*?Div.*?Yield.*?<td class.*?>(.*?)<\/td>/)
 {
 #dont process if no market cap
 #if ($content =~ m/Market Cap:<\/th><td class\=\"yfnc_tabledata1\">N\/A<\/td>/) {print "NOMARKETCAP\n";return "NOMARKETCAP";}
#if ($content =~ m/.*?time_rtq_ticker.*?><span.*?>(.*?)<\/span>.*?1y Target Est.*?<td class.*?>(.*?)<\/td>.*?52wk Range.*?<span.*?>(.*?)<\/span> - <span>(.*?)<\/span>.*?Volume.*?<span.*?>(.*?)<\/span>.*?Market Cap\:.*?<span.*?>(.*?)<\/span>/)
#{
      #$tickmain =  $1."\t".$2."\t".$3."\t".$4."\t".$5."\t".$6."\t".$7."\t".$8."\t".$9;
      $tickmain =  $1."\t".$2."\t".$3."-".$4."\t".$5."\t".$6."\t".$7."\t".$8."\t".$9;
      $tickmain =~ s/<.*?>//g;
      }
      return   $tickmain;
}


sub getmain2
{
  my $contref = shift;
  my $content = $$contref;
  my ($tickmain);
  if ($content =~ m/Market Cap:<\/th><td class\=\"yfnc_tabledata1\">N\/A<\/td>/) {print "NOMARKETCAP\n";return "NOMARKETCAP";}
if ($content =~ m/.*?time_rtq_ticker.*?><span.*?>(.*?)<\/span>.*?1y Target Est.*?<td class.*?>(.*?)<\/td>.*?52wk Range\:<\/th><td class\=\"yfnc_tabledata1\">(.*?)<\/td>.*?Volume.*?<span.*?>(.*?)<\/span>.*?Market Cap\:.*?<span.*?>(.*?)<\/span>.*?P\/E .*?\(ttm\).*?<td class.*?>(.*?)<\/td>.*?EPS .*?\(ttm\).*?<td class.*?>(.*?)<\/td>.*?Div.*?Yield.*?<td class.*?>(.*?)<\/td>/)
 {

    #if ($content =~ m/.*?time_rtq_ticker.*?><span.*?>(.*?)<\/span>.*?1y Target Est.*?<td class.*?>(.*?)<\/td>.*?52wk Range.*?<td.*?>(.*?)<\/td>.*?Volume.*?<span.*?>(.*?)<\/span>.*?Market Cap\:.*?<span.*?>(.*?)<\/span>/)
#{
      #$tickmain =  $1."\t".$2."\t".$3."\t".$4."\t".$5."-".$6."\t".$7."\t".$8."\t".$9."\t".$10;
      $tickmain =  $1."\t".$2."\t".$3."-".$3."\t".$4."\t".$5."\t".$6."\t".$7."\t".$8;
      $tickmain =~ s/<.*?>//g;;

      $tickmain =~ s/<.*?>//g;
      
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

sub transformtickerdet
{
   my $str = shift;
   my (%tickerhash) = {};
   my ($Ticker,$name,$sector,$industry,$LastTrade,$yTargetEst,$wkRange,$vol,$MarketCap,$PE,$EPS,$DivYield,$EnterpriseValue,$TrailingPE,$ForwardPE,$PEGRatio,$PriceSales,$PriceBook,$EnterpriseValueRevenue,$EnterpriseValueEBITDA,$FiscalYearEnds,$MostRecentQuarter,$OperatingMargin,$ReturnonAssets,$ReturnonEquity,$Revenue,$RevenuePerShare,$QtrlyRevenueGrowth,$GrossProfit,$EBITDAttm,$NetIncomeAvltoCommon,$DilutedEPS,$QtrlyEarningsGrowth,$TotalCash,$TotalCashPerShare,$TotalDebt,$TotalDebtEquity,$CurrentRatio,$BookValuePerShare,$OperatingCashFlow,$LeveredFreeCashFlow,$Beta,$WeekChange,$SP50052WeekChange,$WeekHigh,$WeekLow,$fiftyDayMovingAverage,$twohundredDayMovingAverage,$SharesOutstanding,$SharesShort,$PayoutRatio,$exdividenddate) = split("\t",$str);
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
   elsif (   $wkRange =~ /.*-(.*)/)
   {
       $diff = $1 - $LastTrade;
       $perdiff = ($diff/$LastTrade) * 100;
       $diff = sprintf("%.2f", $diff);
       $perdiff = sprintf("%.2f", $perdiff);
   }

$tickerhash{NetIncomeAvltoCommon} = $NetIncomeAvltoCommon;
$tickerhash{MostRecentQuarter} = $MostRecentQuarter;
$tickerhash{TotalDebtEquity} = $TotalDebtEquity;
$tickerhash{wkRange} = $wkRange;
$tickerhash{perdiff} = $perdiff;
$tickerhash{TotalCash} = $TotalCash;
$tickerhash{PEGRatio} = $PEGRatio;
$tickerhash{DivYield} = $DivYield;
$tickerhash{ReturnonAssets} = $ReturnonAssets;
$tickerhash{FiscalYearEnds} = $FiscalYearEnds;
$tickerhash{EnterpriseValueRevenue} = $EnterpriseValueRevenue;
$tickerhash{GrossProfit} = $GrossProfit;
$tickerhash{Beta} = $Beta;
$tickerhash{TotalDebt} = $TotalDebt;
$tickerhash{SharesOutstanding} = $SharesOutstanding;
$tickerhash{QtrlyRevenueGrowth} = $QtrlyRevenueGrowth;
$tickerhash{Revenue} = $Revenue;
$tickerhash{name} = $name;
$tickerhash{sector} = $sector;
$tickerhash{exdividenddate} = $exdividenddate;
$tickerhash{WeekLow} = $WeekLow;
$tickerhash{TotalCashPerShare} = $TotalCashPerShare;
$tickerhash{PayoutRatio} = $PayoutRatio;
$tickerhash{diff} = $diff;
$tickerhash{PE} = $PE;
$tickerhash{twohundredDayMovingAverage} = $twohundredDayMovingAverage;
$tickerhash{EnterpriseValueEBITDA} = $EnterpriseValueEBITDA;
$tickerhash{LeveredFreeCashFlow} = $LeveredFreeCashFlow;
$tickerhash{WeekHigh} = $WeekHigh;
$tickerhash{fiftyDayMovingAverage} = $fiftyDayMovingAverage;
$tickerhash{WeekChange} = $WeekChange;
$tickerhash{PriceBook} = $PriceBook;
$tickerhash{OperatingCashFlow} = $OperatingCashFlow;
$tickerhash{BookValuePerShare} = $BookValuePerShare;
$tickerhash{ForwardPE} = $ForwardPE;
$tickerhash{OperatingMargin} = $OperatingMargin;
$tickerhash{DilutedEPS} = $DilutedEPS;
$tickerhash{ReturnonEquity} = $ReturnonEquity;
$tickerhash{EPS} = $EPS;
$tickerhash{PriceSales} = $PriceSales;
$tickerhash{QtrlyEarningsGrowth} = $QtrlyEarningsGrowth;
$tickerhash{yTargetEst} = $yTargetEst;
$tickerhash{vol} = $vol;
$tickerhash{LastTrade} = $LastTrade;
$tickerhash{SharesShort} = $SharesShort;
$tickerhash{RevenuePerShare} = $RevenuePerShare;
$tickerhash{industry} = $industry;
$tickerhash{Ticker} = $Ticker;
$tickerhash{MarketCap} = $MarketCap;
$tickerhash{CurrentRatio} = $CurrentRatio;
$tickerhash{EnterpriseValue} = $EnterpriseValue;
$tickerhash{SP50052WeekChange} = $SP50052WeekChange;
$tickerhash{TrailingPE} = $TrailingPE;
$tickerhash{EBITDA} = $EBITDA;
return %tickerhash;
}
1;
