#!c:\Perl\bin

open (R,"<","C:/Users/thaliath/workspace/tickercrawler/tickdata.txt")  || die "Cannot open file tickdata for reading. $!\n";
open (OUT,">","C:/Users/thaliath/workspace/tickercrawler/tickdatadet.txt") || die "Cannot open file tickdatadet for writing. $!\n";

while (<R>)
{
   chomp;
  $str = $_;
  $str =~ s/N\/A/NULL/g;
  #$str =~ s/\t\t/\tNULL\t/g;
   ($Ticker,$name,$sector,$industry,$LastTrade,$yTargetEst,$wkRange,$vol,$MarketCap,$PE,$EPS,$DivYield,$EnterpriseValue,$TrailingPE,$ForwardPE,$PEGRatio,$PriceSales,$PriceBook,$EnterpriseValueRevenue,$EnterpriseValueEBITDA,$FiscalYearEnds,$MostRecentQuarter,$OperatingMargin,$ReturnonAssets,$ReturnonEquity,$Revenue,$RevenuePerShare,$QtrlyRevenueGrowth,$GrossProfit,$EBITDAttm,$NetIncomeAvltoCommon,$DilutedEPS,$QtrlyEarningsGrowth,$TotalCash,$TotalCashPerShare,$TotalDebt,$TotalDebtEquity,$CurrentRatio,$BookValuePerShare,$OperatingCashFlow,$LeveredFreeCashFlow,$Beta,$WeekChange,$SP50052WeekChange,$WeekHigh,$WeekLow,$fiftyDayMovingAverage,$twohundredDayMovingAverage,$SharesOutstanding,$SharesShort,$PayoutRatio) = split("\t",$str);

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
        print "$Ticker\t$wkRange\t$LastTrade\n";
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



   print OUT "$Ticker\t$name\t$sector\t$industry\t$vol\t$LastTrade\t$yTargetEst\t$wkRange\t$diff\t$perdiff\t$MarketCap\t$PE\t$EPS\t$DivYield\t$EnterpriseValue\t$TrailingPE\t$ForwardPE\t$PEGRatio\t$PriceSales\t$PriceBook\t$EnterpriseValueRevenue\t$EnterpriseValueEBITDA\t$FiscalYearEnds\t$MostRecentQuarter\t$OperatingMargin\t$ReturnonAssets\t$ReturnonEquity\t$Revenue\t$RevenuePerShare\t$QtrlyRevenueGrowth\t$GrossProfit\t$EBITDAttm\t$NetIncomeAvltoCommon\t$DilutedEPS\t$QtrlyEarningsGrowth\t$TotalCash\t$TotalCashPerShare\t$TotalDebt\t$TotalDebtEquity\t$CurrentRatio\t$BookValuePerShare\t$OperatingCashFlow\t$LeveredFreeCashFlow\t$Beta\t$WeekChange\t$SP50052WeekChange\t$WeekHigh\t$WeekLow\t$fiftyDayMovingAverage\t$twohundredDayMovingAverage\t$SharesOutstanding\t$SharesShort\t$PayoutRatio\n";
}
close (R);
close (OUT);
exit 1;