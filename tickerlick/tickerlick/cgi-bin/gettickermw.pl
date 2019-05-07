#!/usr/bin/perl

use lib qw(/home/tickerlick/cgi-bin);
use LWP::Simple;
use DBI;
use JSON;
use Data::Dumper;
my ($dbh,$sth2,$sth1);
my $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
use Redis;
my $redis = Redis->new(server => '127.0.0.1:6379', reconnect => 60);
my $symbol = $ARGV[0];
my (%tick) = getResultsmw($symbol);
sub getResultsmw
{
my ($ticker) = uc shift;
my (%tickhash) ;
my %str =() ;
if ($redis->exists($ticker))
{
   %str = $redis->hgetall($ticker);
}
else
{
  $str->{'Ticker'} = $ticker;
}
print Dumper($str);
$content = get("http://www.marketwatch.com/investing/stock/$ticker");
$content =~ s/\r\n//g;
if ($content =~ /.*?<span class\=\"volume last\-value\">(.*?)<\/span>.*?<span class\=\"last\-value\">(.*?)<\/span>.*?<span class\=\"text low\">(.*?)<\/span>.*?<span class\=\"text high\">(.*?)<\/span>.*?<span class\=\"text low\">(.*?)<\/span>.*?<span class\=\"text high\">(.*?)<\/span>/s)
{
   $v = $1;
   #print "$m,$2,$3,$4,$5,$6\n";
   $str->{'YearHigh'} = $6;
   $str->{'YearLow'} = $5;
   $str->{'DaysHigh'} = $4; 
   $str->{'DaysLow'} = $3;
   $str->{'LastTradePriceOnly'} = $2;
   $v =~ s/\s+//g;
   if ($v =~ /.*K$/){$v *= 1000;}
   elsif ($v =~ /.*M$/){$v *= 1000000;}
   elsif ($v =~ /.*B$/){$v *= 1000000000;}
   $str->{'Volume'} = $v;
}
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
$str->{'LastTradeDate'} = "'".$str->{'LastTradeDate'}."'";
#my ($cols) = "YearLow,OneyrTargetPrice,DividendShare,ChangeFromFiftydayMovingAverage,FiftydayMovingAverage,PercentChangeFromTwoHundreddayMovingAverage,DaysLow,DividendYield,ChangeFromYearLow,ChangeFromYearHigh,EarningsShare,LastTradePriceOnly,YearHigh,LastTradeDate,PreviousClose,Volume,MarketCapitalization,Name,DividendPayDate,ExDividendDate,PERatio,PercentChangeFromFiftydayMovingAverage,ChangeFromTwoHundreddayMovingAverage,DaysHigh,PercentChangeFromYearLow,TwoHundreddayMovingAverage,PercebtChangeFromYearHigh,Open,Symbol";
my ($query);
 %tickhash = transformtickerdet1($str->{'Symbol'},$str->{'LastTradePriceOnly'},$str->{'PreviousClose'},$str->{'OneyrTargetPrice'},$str->{'Volume'},$str->{'YearLow'},$str->{'YearHigh'},$str->{'MarketCapitalization'},$str->{'PERatio'},$str->{'EarningsShare'});
return %tickhash;
}


sub transformtickerdet1
{
   #my $str = shift;
   my (%tickerhash) = {};
   my ($Ticker,$LastTrade,$PrevClose,$yTargetEst,$wkRange,$vol,$MarketCap,$PE,$EPS,$DivYield,$EnterpriseValue,$TrailingPE,$ForwardPE,$PEGRatio,$PriceSales,$PriceBook,$EnterpriseValueRevenue,$EnterpriseValueEBITDA,$FiscalYearEnds,$MostRecentQuarter,$OperatingMargin,$ReturnonAssets,$ReturnonEquity,$Revenue,$RevenuePerShare,$QtrlyRevenueGrowth,$GrossProfit,$EBITDAttm,$NetIncomeAvltoCommon,$DilutedEPS,$QtrlyEarningsGrowth,$TotalCash,$TotalCashPerShare,$TotalDebt,$TotalDebtEquity,$CurrentRatio,$BookValuePerShare,$OperatingCashFlow,$LeveredFreeCashFlow,$Beta,$WeekChange,$SP50052WeekChange,$WeekHigh,$WeekLow,$fiftyDayMovingAverage,$twohundredDayMovingAverage,$SharesOutstanding,$SharesShort,$PayoutRatio,$exdividenddate);
 my ($Ticker,$LastTrade,$PrevClose,$yTargetEst,$vol,$WeekLow,$WeekHigh,$MarketCap,$PE,$EPS)= @_;
    if ($LastTrade == 0) {return null;}
    $wkRange = $WeekLow ."-".$WeekHigh;

   $diff = '';
   if  ($wkRange =~ /A/)
    {
       $diff = "N\/A";
       $perdiff =    "N\/A";
    }
   elsif (   $wkRange =~ /(.*?)-(.*)/)
   {
       $tickerhash{YearLow} = $WeekLow; 
       $tickerhash{YearHigh} = $WeekHigh; 
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
$tickerhash{Beta} = $Beta;
$tickerhash{PE} = $PE;
$tickerhash{ForwardPE} = $ForwardPE;
$tickerhash{EPS} = $EPS;
$tickerhash{yTargetEst} = $yTargetEst;
$tickerhash{vol} = $vol;
$tickerhash{LastTrade} = $LastTrade;
$tickerhash{Ticker} = $Ticker;
$tickerhash{MarketCap} = $MarketCap;
$tickerhash{class} = "Common Stock";
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

getlatestdma1(\%tickerhash);

return %tickerhash;
}

sub getlatestdma1
{
 my $tickerhashref = shift;
my ($ticker_id,$flag,$sth);
my $lasttrade = $$tickerhashref{LastTrade};
 $sql = "select ticker_id,comp_name,sector,industry,tflag from tickermaster where ticker = $$tickerhashref{Ticker}";
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
