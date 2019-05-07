#!/usr/bin/perl

use lib qw(/home/tickerlick/cgi-bin);
use LWP::Simple;
use DBI;
my %rephash = (
      'OS' => 'MACD (5,35,5) Oversold ',
      'OB' =>'MACD (5,35,5) Overbought ',
      'RS' =>'RSI Oversold ',
      'RB' => 'RSI Overbought ',
      'SS' =>'Stochastic Oversold ',
      'SB' => 'Stochastic Overbought ',
      'BBU' => 'Bollinger Oversold ',
      'BBE' => 'Bollinger Overbought ',
    );
sub getResults
{
my ($ticker) = uc shift;
my %tickerhash = {};
my ($lasttrade,$curncy,$lt_time,$eps,$yearlow,$yearhigh,$prevclose,$oneyrtarget,$vol,$fiftydayave,$twohundreddayave,$pe,$mktcap) = "";;
my $rtqstr = get ("http://finance.google.com/finance/info?client=ig&q=$ticker");
my $content = get("http://query.yahooapis.com/v1/public/yql?q=select%20%2a%20from%20yahoo.finance.quotes%20where%20symbol%20in%20%28%22".$ticker."%22%29&env=store://datatables.org/alltableswithkeys");
$rtqstr =~ s/\n/ /g;
#print "$rtqstr\n";
#print "$content\n";
if ($rtqstr =~ /.*?l_cur.*?\:.*?\"(.*?)\"/)
{
      $tickerhash{lasttrade} = $1;
}
else
{
     $tickerhash{lasttrade} = 0;
}

if ($content =~ /<Currency>/)
{
    $tickerhash{valid} = 1;
}
else
{
   $tickhash{invalidticker} = 1;
}
if ($content =~ /<Currency>(.*?)<\/Currency>/){$tickerhash{curncy} = $1;}
if ($content =~ /<LastTradeDate>(.*?)<\/LastTradeDate>/){$tickerhash{lttime} = $1;}
if ($content =~ /<EarningsShare>(.*?)<\/EarningsShare>/){$tickerhash{eps} = $1;}
if ($content =~ /<YearLow>(.*?)<\/YearLow>/){$tickerhash{yearlow} = $1;}
if ($content =~ /<YearHigh>(.*?)<\/YearHigh>/){$tickerhash{yearhigh} = $1;}
if ($content =~ /<PreviousClose>(.*?)<\/PreviousClose>/){$tickerhash{prevclose} = $1;}
if ($content =~ /<OneyrTargetPrice>(.*?)<\/OneyrTargetPrice>/){$tickerhash{oneyrtarget} = $1;}
if ($content =~ /<Volume>(.*?)<\/Volume>/){$tickerhash{vol} = $1;}
#if ($content =~ /<FiftydayMovingAverage>(.*?)<\/FiftydayMovingAverage>/){$tickerhash{fiftydayave} = $1;}
#if ($content =~ /<TwoHundreddayMovingAverage>(.*?)<\/TwoHundreddayMovingAverage>/){$tickerhash{twohundreddayave} = $1;}
if ($content =~ /<MarketCapitalization>(.*?)<\/MarketCapitalization>/){$tickerhash{mktcap} = $1;}
if ($content =~ /<PERatio>(.*?)<\/PERatio>/){$tickerhash{pe} = $1;}
if ($content =~ /<DividendYield>(.*?)<\/DividendYield>/){$tickerhash{divyield} = $1;}
#print  "$ticker,$lasttrade,$curncy,$lt_time,$eps,$yearlow,$yearhigh,$prevclose,$oneyrtarget,$vol,$fiftydayave,$twohundreddayave,$pe,$mktcap\n";
   $tickerhash{ticker} = $ticker;
    if ($lasttrade == 0) {return undef;}
        $wkRange = $tickerhash{yearlow} ."-".$tickerhash{yearhigh};

     $diff = '';
   if  (!$tickerhash{yearlow} && !$tickerhash{yearhigh})
    {
       $diff = "N\/A";
       $perdiff =    "N\/A";
    }
   else
   {
    if ($tickerhash{yearhigh})
      { 
       $diffhigh = $tickerhash{yearhigh} - $lasttrade;
       $perdiffhigh = abs(($diffhigh/$tickerhash{yearhigh})) * 100;
       $tickerhash{diffhigh} = sprintf("%.2f", $diffhigh);
       $tickerhash{perdiffhigh} = abs(sprintf("%.2f", $perdiffhigh));
      }
     if ($tickerhash{yearlow})
      {
       $difflow = $tickerhash{yearlow} - $lasttrade;
       $perdifflow = abs(($difflow/$tickerhash{yearlow})) * 100;
       $tickerhash{difflow} = sprintf("%.2f", $difflow);
       $tickerhash{perdifflow} = abs(sprintf("%.2f", $perdifflow));
      }
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
$tickerhash{pricediff} = abs($tickerhash{lasttrade} - $tickerhash{prevclose});
$tickerhash{pricediff} = sprintf("%.2f", $tickerhash{pricediff});
$tickerhash{pricediffper} = abs(sprintf("%.2f",($tickerhash{pricediff}/$tickerhash{prevclose}) * 100));
#print "tom:$tickerhash{pricediffper}\n";
if ($tickerhash{prevclose} < $tickerhash{lasttrade})
{
  $tickerhash{pricestat} = "up";
  }
  else
  {
    $tickerhash{pricestat} = "down";
 }

#getlatestdma
my ($ticker_id,$flag);
my $lasttrade = $tickerhashref{LastTrade};
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
 $sql = "select ticker_id,comp_name,sector,industry from tickermaster where ticker = '$tickerhashref{Ticker}'";
#print "tom1:$sql\n";
  $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
  $ticker_id = $row[0];
  $tickerhashref{name} = $row[1];
  $tickerhashref{sector} = $row[2];
  $tickerhashref{industry} = $row[3];
}
if (!$ticker_id)
{
 $tickerhashref{dma50} = "N\/A";
 $tickerhashref{dma50} = "N\/A";
 $tickerhashref{dma200} = "N\/A";
 next;
}
 $sql ="select dma_10, dma_50, dma_200 from tickerprice a where a.ticker_id = $ticker_id ORDER BY a.price_date DESC LIMIT 0,1;";
#print "tom2:$sql\n";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array)
 {
  $tickerhashref{dma10} = $row[0] || "N\/A";
  $tickerhashref{dma50} = $row[1] || "N\/A";
  $tickerhashref{dma200} = $row[2] || "N\/A";
  $flag = 1;
}
 $sth->finish;
 if (!$flag)
{
 $tickerhashref{dma10} = "N\/A";;
 $tickerhashref{dma50} = "N\/A";
 $tickerhashref{dma200} = "N\/A";
}
else
{
 $tickerhashref{dma10diff} = abs(sprintf("%.2f", $tickerhashref{dma10} - $lasttrade));
 if ($tickerhashref{dma10}  && $tickerhashref{dma10} > 0)
{
 $tickerhashref{dma10diffper} = abs(sprintf("%.2f",($tickerhashref{dma10diff}/$tickerhashref{dma10}) * 100));
}
 $tickerhashref{dma50diff} = abs(sprintf("%.2f", $tickerhashref{dma50} - $lasttrade));
 if ($tickerhashref{dma50}  && $tickerhashref{dma50} > 0)
{
 $tickerhashref{dma50diffper} = abs(sprintf("%.2f",($tickerhashref{dma50diff}/$tickerhashref{dma50}) * 100));
}
 $tickerhashref{dma200diff} = abs(sprintf("%.2f", $tickerhashref{dma200} - $lasttrade));
if ($tickerhashref{dma200} && $tickerhashref{dma200} > 0)
{
 $tickerhashref{dma200diffper} = abs(sprintf("%.2f",($tickerhashref{dma200diff}/$tickerhashref{dma200}) * 100));
}
 if ($tickerhashref{dma10} < $lasttrade)
 {
  $tickerhashref{dma10stat} = "up";
 }
 else
 {
  $tickerhashref{dma10stat} = "down";
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
return %tickerhash;
}
1;
