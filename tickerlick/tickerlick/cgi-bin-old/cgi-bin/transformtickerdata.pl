#!/usr/bin/perl
use lib qw(/home/tickerlick/cgi-bin);
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
   if ($MarketCap =~ m/(.*)M/)
   {
        $MarketCap = $1;
   }
     elsif ($MarketCap =~ m/(.*)B/)
   {
        $MarketCap = $1 * 1000;
   }
    elsif ($MarketCap =~ m/(.*)K/)
   {
        $MarketCap = $1 / 1000;
   }
     if ($EnterpriseValue =~ m/(.*)M/)
   {
        $EnterpriseValue = $1;
   }
    elsif ($EnterpriseValue =~ m/(.*)B/)
   {
        $EnterpriseValue = $1 * 1000;
   }
     elsif ($EnterpriseValue =~ m/(.*)K/)
   {
        $EnterpriseValue = $1 / 1000;
   }
      if ($Revenue =~ m/(.*)M/)
   {
        $Revenue = $1;
   }
    elsif ($Revenue =~ m/(.*)B/)
   {
        $Revenue = $1 * 1000;
   }
    elsif ($Revenue =~ m/(.*)K/)
   {
        $Revenue = $1 / 1000;
   }
       if ($GrossProfit =~ m/(.*)M/)
   {
       $GrossProfit = $1;
   }
    elsif ($GrossProfit =~ m/(.*)B/)
   {
        $GrossProfit = $1 * 1000;
   }
    elsif ($GrossProfit =~ m/(.*)K/)
   {
        $GrossProfit = $1 / 1000;
   }
    if ($TotalDebt =~ m/(.*)M/)
   {
       $TotalDebt = $1;
   }
    elsif ($TotalDebt =~ m/(.*)B/)
   {
        $TotalDebt = $1 * 1000;
   }
    elsif ($TotalDebt =~ m/(.*)K/)
   {
        $TotalDebt = $1 / 1000;
   }
       if ($NetIncomeAvltoCommon =~ m/(.*)M/)
   {
      $NetIncomeAvltoCommon = $1;
   }
    elsif ($NetIncomeAvltoCommon =~ m/(.*)B/)
   {
        $NetIncomeAvltoCommon = $1 * 1000;
   }
    elsif ($NetIncomeAvltoCommon =~ m/(.*)K/)
   {
        $NetIncomeAvltoCommon = $1 / 1000;
   }

   if ($TotalCash =~ m/(.*)M/)
   {
     $TotalCash = $1;
   }
    elsif ($TotalCash =~ m/(.*)B/)
   {
        $TotalCash = $1 * 1000;
   }
    elsif ($TotalCash =~ m/(.*)K/)
   {
        $TotalCash = $1 / 1000;
   }
    if ($EBITDAttm =~ m/(.*)M/)
   {
     $EBITDAttm = $1;
   }
    elsif ($EBITDAttm =~ m/(.*)B/)
   {
        $EBITDAttm = $1 * 1000;
   }
    elsif ($EBITDAttm =~ m/(.*)K/)
   {
        $EBITDAttm = $1 / 1000;
   }
    if ($OperatingCashFlow =~ m/(.*)M/)
   {
     $OperatingCashFlow = $1;
   }
    elsif ($OperatingCashFlow =~ m/(.*)B/)
   {
        $OperatingCashFlow = $1 * 1000;
   }
    elsif ($OperatingCashFlow =~ m/(.*)K/)
   {
       $OperatingCashFlow = $1 / 1000;
   }
     if ($LeveredFreeCashFlow =~ m/(.*)M/)
   {
     $LeveredFreeCashFlow = $1;
   }
    elsif ($LeveredFreeCashFlow =~ m/(.*)B/)
   {
        $LeveredFreeCashFlow = $1 * 1000;
   }
    elsif ($LeveredFreeCashFlow =~ m/(.*)K/)
   {
       $LeveredFreeCashFlow = $1 / 1000;
   }
        if ($SharesOutstanding =~ m/(.*)M/)
   {
    $SharesOutstanding = $1;
   }
    elsif ($SharesOutstanding =~ m/(.*)B/)
   {
        $SharesOutstanding = $1 * 1000;
   }
    elsif ($SharesOutstanding =~ m/(.*)K/)
   {
      $SharesOutstanding = $1 / 1000;
   }
          if ($SharesShort =~ m/(.*)M/)
   {
    $SharesShort = $1;
   }
    elsif ($SharesShort =~ m/(.*)B/)
   {
        $SharesShort = $1 * 1000;
   }
    elsif ($SharesShort =~ m/(.*)K/)
   {
     $SharesShort = $1 / 1000;
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
print "$tickerhash{LastTrade}\n";
return %tickerhash;
}
