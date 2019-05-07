#!/usr/bin/perl

use lib qw(/home/tickerlick/cgi-bin);
use LWP::Simple;
use DBI;
my (%rephash);
$rephash{'OS'} = 'MACD (5,35,5) Oversold';
$rephash{'OB'} ='MACD (5,35,5) Overbought';
$rephash{'RS'} ='RSI Oversold';
$rephash{'RB'} = 'RSI Overbought';
$rephash{'SS'} ='Stochastic Oversold';
$rephash{'SB'} = 'Stochastic Overbought';
$rephash{'BBU'} = 'Bollinger Oversold';
$rephash{'BBE'} = 'Bollinger Overbought';

my (%ratinghash);
$ratinghash{'U'} = 'Upgrade';
$ratinghash{'D'} = 'Downgrade';
$ratinghash{'P'} = 'Price';
$ratinghash{'I'} = 'Initiated';

sub getResults
{
my ($ticker) = uc shift;
my (%tickhash) ;
my   $tickdata = "";
my  $tickmain = "";
my   $tickdesc = "";
my $tickprofile = "";
my   $content = get("http://finance.yahoo.com/q?s=$ticker");

if ($content)
{
$content =~ s/\n//g;
if ($content =~ m/There are no All Markets results for|Get Quotes Results for /)
{
 $tickhash{invalidticker} = 1;
 return %tickhash;
}
else
{
  $tickhash{invalidticker} = 0;
} 
print "$content\n";
exit 1;
#if ($content =~ m/.*?time_rtq_ticker\"><.*?>(.*?)<\/span>1y Target Est.*?td class.*?>(.*?)<\/td>.*?52wk Range.*?td class.*?><span>(.*?)<\/span> \- <span>(.*?)<\/span><\/td>.*?Market Cap\:.*?<span id.*?>(.*?)<\/span>.*?P\/E .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?EPS .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?Div.*?Yield.*?td class.*?>(.*?)<\/td>/i)  {
if ($content =~ /(\>NAV\&|SPDR|Market Vectors|\sETN\s|Direxion|ProShare|EGShares|PowerShares|Global\sX|Sprott|Cambria|PIMCO|QuantShares|DBX\s|\sETF\s\($ticker\)|AlphaDEX|FactorShares|FlexShares)/)
{
 if ($content =~ m/52wk Range.*?td class.*?>N\/A<\/td>/ )
{
$tickmain = getetfmain1(\$content);
}
else
{
 $tickmain = getetfmain2(\$content);
 }
 $content = get("http://finance.yahoo.com/q/pr?s=$ticker+Profile");

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
if ($content =~ m/52wk Range\:<\/th><td class\=\"yfnc_tabledata1\">N\/A<\/td>/)
{
$tickmain = getmain2(\$content);
}
else
{
 $tickmain = getmain1(\$content);
 }


 #$content = get("http://finance.yahoo.com/q/pr?s=$ticker+Profile");

#die "Couldn't get it!" unless defined $content;

#if ($content)
#{
#$content =~ s/\n//g;
#$tickprofile = getprofile(\$content);
#}
  #$content = get("http://finance.yahoo.com/q/ks?s=$ticker+Key+Statistics");
  #if ($content)
  #{
  #$content =~ s/\n//g;
 #if ($content =~ m/Market Cap \(intraday\).*?<span id.*?>(.*?)<\/span>.*?Enterprise Value.*?td class.*?>(.*?)<\/td>.*?Trailing P\/E.*?td class.*?>(.*?)<\/td>.*?Forward P\/E.*?td class.*?>(.*?)<\/td>.*?PEG Ratio.*?td class.*?>(.*?)<\/td>.*?Price\/Sales.*?td class.*?>(.*?)<\/td>.*?Price\/Book.*?td class.*?>(.*?)<\/td>.*?Enterprise Value\/Revenue.*?td class.*?>(.*?)<\/td>.*?Enterprise Value\/EBITDA.*?td class.*?>(.*?)<\/td>.*?Fiscal Year Ends.*?td class.*?>(.*?)<\/td>.*?Most Recent Quarter.*?td class.*?>(.*?)<\/td>.*?Operating Margin.*?td class.*?>(.*?)<\/td>.*?Return on Assets.*?td class.*?>(.*?)<\/td>.*?Return on Equity.*?td class.*?>(.*?)<\/td>.*?Revenue.*?td class.*?>(.*?)<\/td>.*?Revenue Per Share.*?td class.*?>(.*?)<\/td>.*?Qtrly Revenue Growt.*?td class.*?>(.*?)<\/td>.*?Gross Profit.*?td class.*?>(.*?)<\/td>.*?EBITDA \(ttm\).*?td class.*?>(.*?)<\/td>.*?Net Income Avl to Common.*?td class.*?>(.*?)<\/td>.*?Diluted EPS.*?td class.*?>(.*?)<\/td>.*?Qtrly Earnings Growth.*?td class.*?>(.*?)<\/td>.*?Total Cash.*?td class.*?>(.*?)<\/td>.*?Total Cash Per Share.*?td class.*?>(.*?)<\/td>.*?Total Debt.*?td class.*?>(.*?)<\/td>.*?Total Debt\/Equity.*?td class.*?>(.*?)<\/td>.*?Current Ratio.*?td class.*?>(.*?)<\/td>.*?Book Value Per Share.*?td class.*?>(.*?)<\/td>.*?Operating Cash Flow.*?td class.*?>(.*?)<\/td>.*?Levered Free Cash Flow.*?td class.*?>(.*?)<\/td>.*?Beta\:.*?td class.*?>(.*?)<\/td>.*?52\-Week Change.*?td class.*?>(.*?)<\/td>.*?S.*?P500 52\-Week Change.*?td class.*?>(.*?)<\/td>.*?52\-Week High.*?td class.*?>(.*?)<\/td>.*?52\-Week Low.*?td class.*?>(.*?)<\/td>.*?50\-Day Moving Average.*?td class.*?>(.*?)<\/td>.*?200\-Day Moving Average.*?td class.*?>(.*?)<\/td>.*?Shares Outstanding.*?td class.*?>(.*?)<\/td>.*?Shares Short.*?\).*?td class.*?>(.*?)<\/td>.*?Payout Ratio.*?td class.*?>(.*?)<\/td>.*?Ex\-Dividend Date.*?<td.*?>(.*?)<\/td>/i){
 #        $tickdesc = $2."\t".$3."\t".$4."\t".$5."\t".$6."\t".$7."\t".$8."\t".$9."\t".$10."\t".$11."\t".$12."\t".$13."\t".$14."\t".$15."\t".$16."\t".$17."\t".$18."\t".$19."\t".$20."\t".$21."\t".$22."\t".$23."\t".$24."\t".$25."\t".$26."\t".$27."\t".$28."\t".$29."\t".$30."\t".$31."\t".$32."\t".$33."\t".$34."\t".$35."\t".$36."\t".$37."\t".$38."\t".$39."\t".$40."\t".$41;
 #        }
 #  else
 #{
     #print "undefined det2:$ticker\n";
     #return null;
 #}
 #}
 #else
 #{
     #print "undefined det1:$ticker\n";
     #return null;
 #}
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
   
    if ($content =~ m/Market Cap:<\/th><td class\=\"yfnc_tabledata1\">N\/A<\/td>/) {return "NOMARKETCAP";}
if ($content =~ m/.*?time_rtq_ticker.*?><span.*?>(.*?)<\/span>.*?Prev Close.*?<td class.*?>(.*?)<\/td>.*?1y Target Est.*?<td class.*?>(.*?)<\/td>.*?52wk Range.*?<span.*?>(.*?)<\/span> - <span>(.*?)<\/span>.*?Volume.*?<span.*?>(.*?)<\/span>.*?Market Cap\:.*?<span.*?>(.*?)<\/span>.*?P\/E .*?\(ttm\).*?<td class.*?>(.*?)<\/td>.*?EPS .*?\(ttm\).*?<td class.*?>(.*?)<\/td>.*?Div.*?Yield.*?<td class.*?>(.*?)<\/td>/)
 {
 #dont process if no market cap
 #if ($content =~ m/Market Cap:<\/th><td class\=\"yfnc_tabledata1\">N\/A<\/td>/) {return "NOMARKETCAP";}
#if ($content =~ m/.*?time_rtq_ticker.*?><span.*?>(.*?)<\/span>.*?1y Target Est.*?<td class.*?>(.*?)<\/td>.*?52wk Range.*?<span.*?>(.*?)<\/span> - <span>(.*?)<\/span>.*?Volume.*?<span.*?>(.*?)<\/span>.*?Market Cap\:.*?<span.*?>(.*?)<\/span>/)
#{
      #$tickmain =  $1."\t".$2."\t".$3."\t".$4."\t".$5."\t".$6."\t".$7."\t".$8."\t".$9;
      #$tickmain =  $1."\t".$2."\t".$3."-".$4."\t".$5."\t".$6."\t".$7."\t".$8."\t".$9;
      $tickmain =  $1."\t".$2."\t".$3."\t".$4."-".$5."\t".$6."\t".$7."\t".$8."\t".$9."\t".$10; 
      $tickmain =~ s/<.*?>//g;
      }
      return   $tickmain;
}


sub getmain2
{
  my $contref = shift;
  my $content = $$contref;
  my ($tickmain);
  if ($content =~ m/Market Cap:<\/th><td class\=\"yfnc_tabledata1\">N\/A<\/td>/) {return "NOMARKETCAP";}
if ($content =~ m/.*?time_rtq_ticker.*?><span.*?>(.*?)<\/span>.*?Prev Close.*?<td class.*?>(.*?)<\/td>.*?1y Target Est.*?<td class.*?>(.*?)<\/td>.*?52wk Range\:<\/th><td class\=\"yfnc_tabledata1\">(.*?)<\/td>.*?Volume.*?<span.*?>(.*?)<\/span>.*?Market Cap\:.*?<span.*?>(.*?)<\/span>.*?P\/E .*?\(ttm\).*?<td class.*?>(.*?)<\/td>.*?EPS .*?\(ttm\).*?<td class.*?>(.*?)<\/td>.*?Div.*?Yield.*?<td class.*?>(.*?)<\/td>/)
 {

    #if ($content =~ m/.*?time_rtq_ticker.*?><span.*?>(.*?)<\/span>.*?1y Target Est.*?<td class.*?>(.*?)<\/td>.*?52wk Range.*?<td.*?>(.*?)<\/td>.*?Volume.*?<span.*?>(.*?)<\/span>.*?Market Cap\:.*?<span.*?>(.*?)<\/span>/)
#{
      #$tickmain =  $1."\t".$2."\t".$3."\t".$4."\t".$5."-".$6."\t".$7."\t".$8."\t".$9."\t".$10;
      $tickmain =  $1."\t".$2."\t".$3."\t".$4."-".$4."\t".$5."\t".$6."\t".$7."\t".$8."\t".$9;
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

 sub getetfmain1
{
  my $contref = shift;
  my $content = $$contref;
  my($tickmain);
  #.*?NAV\&.*?td class.*?>(.*?)<\/td>.*?52wk Range.*?td class.*?><span>(.*?)<\/span> \- <span>(.*?)<\/span><\/td>.*?Volume.*?<span id.*?>(.*?)<\/span>.*?P\/E .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?Yield.*?td class.*?>(.*?)<\/td>/)
 if ($content =~ m/time_rtq_ticker.*?<span id.*?>(.*?)<\/span>.*?Prev Close.*?<td class.*?>(.*?)<\/td>.*?NAV\&.*?td class.*?>(.*?)<\/td>.*?52wk Range.*?td class.*?><span>(.*?)<\/span> \- <span>(.*?)<\/span><\/td>.*?Volume.*?<span id.*?>(.*?)<\/span>.*?P\/E .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?Yield.*?td class.*?><yield>(.*?)<\/yield><\/td>/)
  {

      #$tickmain =  $1."\t".$3."\t".$4."\t".$5."\t".$6."\t".$7."\t".$8."\t".$9;
      $tickmain =  $1."\t".$2."\t".$3."\t".$4."-".$5."\t".$6."\t".$7."\t".$8;
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
if ($content =~ m/time_rtq_ticker.*?<span id.*?>(.*?)<\/span>.*?Prev Close.*?<td class.*?>(.*?)<\/td>.*?NAV\&.*?td class.*?>(.*?)<\/td>.*?52wk Range.*?td class.*?><span>(.*?)<\/span> \- <span>(.*?)<\/span><\/td>.*?Volume.*?<span id.*?>(.*?)<\/span>.*?P\/E .*?\(ttm\).*?td class.*?>(.*?)<\/td>.*?Yield.*?td class.*?>(.*?)<\/td>/)
#if ($content =~ m/time_rtq_ticker.*?<span id.*?>(.*?)<\/span>.*?1y Target Est.*?td class.*?>(.*?)<\/td>/)
{
      #$tickmain =  $1."\t".$2."\t".$3."-".$4."\t".$5."\t".$6."\t".$7;
      $tickmain =  $1."\t".$2."\t".$3."\t".$4."-".$5."\t".$6."\t".$7."\t".$8;
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
if ($content =~ m/<title>.*?\|(.*?)Stock.*?Sector:.*?<a href.*?>(.*?)<\/a>.*?Industry:.*?<a href.*?>(.*?)<\/a>/)
{
     
      $tickprofile =  $1;
      }
elsif ($content =~ m/<title>.*?\|(.*?)Stock/)
   {
       $tickprofile =  $1;
   }
else
 {
    $tickprofile =  "N\/A";
   
 }
      $tickprofile =~ s/\&amp\;/\&/g;    
      return   $tickprofile;

}

sub transformtickerdet
{
   my $str = shift;
   my (%tickerhash) = {};
   my ($Ticker,$LastTrade,$PrevClose,$yTargetEst,$wkRange,$vol,$MarketCap,$PE,$EPS,$DivYield,$EnterpriseValue,$TrailingPE,$ForwardPE,$PEGRatio,$PriceSales,$PriceBook,$EnterpriseValueRevenue,$EnterpriseValueEBITDA,$FiscalYearEnds,$MostRecentQuarter,$OperatingMargin,$ReturnonAssets,$ReturnonEquity,$Revenue,$RevenuePerShare,$QtrlyRevenueGrowth,$GrossProfit,$EBITDAttm,$NetIncomeAvltoCommon,$DilutedEPS,$QtrlyEarningsGrowth,$TotalCash,$TotalCashPerShare,$TotalDebt,$TotalDebtEquity,$CurrentRatio,$BookValuePerShare,$OperatingCashFlow,$LeveredFreeCashFlow,$Beta,$WeekChange,$SP50052WeekChange,$WeekHigh,$WeekLow,$fiftyDayMovingAverage,$twohundredDayMovingAverage,$SharesOutstanding,$SharesShort,$PayoutRatio,$exdividenddate);
 my ($Ticker,$LastTrade,$PrevClose,$yTargetEst,$wkRange,$vol,$MarketCap,$PE,$EPS)= split("\t",$str);
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
       $perdiffhigh = abs(($diffhigh/$tickerhash{YearHigh})) * 100;
       $tickerhash{diffhigh} = sprintf("%.2f", $diffhigh);
       $tickerhash{perdiffhigh} = abs(sprintf("%.2f", $perdiffhigh));
       $difflow = $tickerhash{YearLow} - $LastTrade;
       $perdifflow = abs(($difflow/$tickerhash{YearLow})) * 100;
       $tickerhash{difflow} = sprintf("%.2f", $difflow);
       $tickerhash{perdifflow} = abs(sprintf("%.2f", $perdifflow));
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
$tickerhash{NetIncomeAvltoCommon} = $NetIncomeAvltoCommon;
$tickerhash{MostRecentQuarter} = $MostRecentQuarter;
$tickerhash{TotalDebtEquity} = $TotalDebtEquity;
$tickerhash{wkRange} = $wkRange;
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
$tickerhash{RevenuePerShare} = $RevenuePerShare;
#$tickerhash{name} = $name;
#$tickerhash{sector} = $sector;
$tickerhash{exdividenddate} = $exdividenddate;
$tickerhash{WeekLow} = $WeekLow;
$tickerhash{TotalCashPerShare} = $TotalCashPerShare;
$tickerhash{PayoutRatio} = $PayoutRatio;
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
#$tickerhash{industry} = $industry;
$tickerhash{Ticker} = $Ticker;
$tickerhash{MarketCap} = $MarketCap;
$tickerhash{CurrentRatio} = $CurrentRatio;
$tickerhash{EnterpriseValue} = $EnterpriseValue;
$tickerhash{SP50052WeekChange} = $SP50052WeekChange;
$tickerhash{TrailingPE} = $TrailingPE;
$tickerhash{EBITDA} = $EBITDA;
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
       $perdiffhigh = abs(($diffhigh/$tickerhash{YearHigh})) * 100;
       $tickerhash{diffhigh} = sprintf("%.2f", $diffhigh);
       $tickerhash{perdiffhigh} = abs(sprintf("%.2f", $perdiffhigh));
       $difflow = $tickerhash{YearLow} - $LastTrade;
       $perdifflow = abs(($difflow/$tickerhash{YearLow})) * 100;
       $tickerhash{difflow} = sprintf("%.2f", $difflow);
       $tickerhash{perdifflow} = abs(sprintf("%.2f", $perdifflow));
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
 my (@arrdata,@arrcrossover,@arrdata2,@arrcrossover2);
 my (%crossoverhash) = ( 
                         Bullish => Buy,
                         Bearish  => Sell,
                         nochange => '&nbsp;',
                        ); 
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
 $sql ="select a.price_date, a.close_price,ema_diff,ema_macd_9, (ema_diff - ema_macd_9) as signalstrength, ema_diff_5_35,ema_macd_5, (ema_diff_5_35 - ema_macd_5) as signalstrength2 from tickerprice a where a.ticker_id = $ticker_id ORDER BY a.price_date DESC LIMIT 0,$no_of_days;";
  my $resulthtml  = '<table border="1" cellpadding="1" cellspacing="1" width="70%" align="center" style="border-collapse: collapse;">';
 $resulthtml  .= '<tr bgcolor="#00FFFF"><th colspan=12>MACD Signal and Crossover Data for the last 100 days</th></tr>';
 $resulthtml  .= '<tr bgcolor="#00FFFF"><th colspan=2>Price History</th><th colspan=5>MACD(12,26,9) Signal and Crossover Data for the last 100 days</th><th colspan=5>MACD(5,35,5) Signal and Crossover Data for the last 100 days</th></tr>';
 $resulthtml .= '<tr bgcolor="#00FFFF"><td>Price Date</td><td>Close Price</td><td>MACD Line(12,26)</td><td>Signal(9 Dy MACD EMA)</td><td>Histogram</td><td>Trend</td><td>Crossover</td><td>MACD Line(5,35)</td><td>Signal(5 Dy MACD EMA)</td><td>Histogram</td><td>Trend</td><td>Crossover</td></tr>';
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 #select ema_5,ema_35,ema_diff_5_35,ema_macd_5
 while (@row = $sth->fetchrow_array)
 {
  $rowcount++;
  
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
$row[2] = sprintf("%.3f", $row[2]);
$row[3] = sprintf("%.3f", $row[3]);
$row[4] = sprintf("%.3f", $row[4]);
$rowhtml = "<tr><td>$row[0]</td><td>$row[1]</td><td>$row[2]</td><td>$row[3]</td><td>$row[4]</td><td>$signalhtml</td>";

push (@arrdata, $rowhtml);
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
$row[5] = sprintf("%.3f", $row[5]);
$row[6] = sprintf("%.3f", $row[6]);
$row[7] = sprintf("%.3f", $row[7]);

$rowhtml2 = "<td>$row[5]</td><td>$row[6]</td><td>$row[7]</td><td>$signalhtml2</td>";


push (@arrdata2, $rowhtml2);
if (!$signallast2)
{
 #print "4:$rowcount,$rowprev2,$signallast2,$signal2\n";
 $signallast2 = $signal2;
 $arrcrossover2[$rowcount] = "<td>$crossoverhash{'nochange'}</td></tr>";
 
}
else
{
if ($signallast2 ne $signal2) #crossover
 {
     $rowprev2 = $rowcount - 2;
      #print "5:$rowcount,$rowprev2,$signallast2,$signal2\n";
     
     if ($crossoverhash{$signallast2} eq 'Buy')
     {
       $arrcrossover2[$rowprev2] = '<td><b><font color="#05840C">'.$crossoverhash{$signallast2}.'</font></b></td></tr>';  
     }
     elsif ($crossoverhash{$signallast2} eq 'Sell')
      {
        $arrcrossover2[$rowprev2] = '<td><b><font color="#FF0000">'.$crossoverhash{$signallast2}.'</font></b></td></tr>';
       }
       else
       {
        $arrcrossover2[$rowprev2] = "<td>$crossoverhash{$signallast2}</td></tr>";
       } 
     $arrcrossover2[$rowcount - 1] = "<td>$crossoverhash{'nochange'}</td></tr>";
     $signallast2 = $signal2;
 }
  else
  {
    #print "6:$rowcount,$rowprev2,$signallast2,$signal2\n";
    $arrcrossover2[$rowcount - 1] = "<td>$crossoverhash{'nochange'}</td></tr>";
    if ($rowcount == 2 && $arrcrossover[0] !~ /Buy|Sell/)
    {
        $arrcrossover2[0] = "<td>$crossoverhash{'nochange'}</td>";
    }

  }
  
  }
}

my $recno = 0;

while ($recno < $rowcount)
{
   $resulthtml .=  $arrdata[$recno].$arrcrossover[$recno].$arrdata2[$recno].$arrcrossover2[$recno];
   #print "$arrdata[$key].$arrcrossover[$key]\n";
   $recno++;
}
$resulthtml .= "</td></tr></table>";
 $sth->finish;
 #$dbh->disconnect; 
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
