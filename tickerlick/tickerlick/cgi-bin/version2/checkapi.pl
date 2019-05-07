#!/usr/bin/perl
use LWP::Simple;
my ($ticker_id,$ticker,@rest,$str,$year,$mon,$day);
my ($close_prc,$curncy,$lt_time,$eps,$yearlow,$yearhigh,$prevclose,$oneyrtarget,$vol,$fiftydayave,$twohundreddayave,$pe,$mktcap);
open (out, ">/home/tthaliath/tickerdata/history/price/daily/apicheck.csv");

            open (F,"</home/tthaliath/tickerlick/daily/ustickermaster_20150402.csv");

            while (<F>)
           {

                   chomp;
                  my ($ticker_id,$ticker,@rest) = split (/\,/,$_);
my $yahortq = 'http://finance.yahoo.com/webservice/v1/symbols/aapl/quote?format=json';
my $rtqstr = get ("http://finance.google.com/finance/info?client=ig&q=$ticker");
my $content = get("http://query.yahooapis.com/v1/public/yql?q=select%20%2a%20from%20yahoo.finance.quotes%20where%20symbol%20in%20%28%22".$ticker."%22%29&env=store://datatables.org/alltableswithkeys");
$rtqstr =~ s/\n/ /g;
($close_prc,$curncy,$lt_time,$eps,$yearlow,$yearhigh,$prevclose,$oneyrtarget,$vol,$fiftydayave,$twohundreddayave,$pe,$mktcap) = "";
#print "$rtqstr\n";
#print "$content\n";
if ($rtqstr =~ /.*?l_cur.*?\:.*?\"(.*?)\"/)
{
      $close_prc = $1;
      $str1 = $ticker.",".$close_prc;
}
else
{
   $str1 = "$ticker,invalid1";
}

if ($content =~ /<Currency>/)
{
    $str1 =  $str1.",valid";
}
else
{
  $str1 =  $str1.",invalid2";
}
if ($content =~ /<Currency>(.*?)<\/Currency>/){$curncy = $1;}
if ($content =~ /<LastTradeDate>(.*?)<\/LastTradeDate>/){$lt_time = $1;}
if ($content =~ /<EarningsShare>(.*?)<\/EarningsShare>/){$eps = $1;}
if ($content =~ /<YearLow>(.*?)<\/YearLow>/){$yearlow = $1;}
if ($content =~ /<YearHigh>(.*?)<\/YearHigh>/){$yearhigh = $1;}
if ($content =~ /<PreviousClose>(.*?)<\/PreviousClose>/){$prevclose = $1;}
if ($content =~ /<OneyrTargetPrice>(.*?)<\/OneyrTargetPrice>/){$oneyrtarget = $1;}
if ($content =~ /<Volume>(.*?)<\/Volume>/){$vol = $1;}
if ($content =~ /<FiftydayMovingAverage>(.*?)<\/FiftydayMovingAverage>/){$fiftydayave = $1;}
if ($content =~ /<TwoHundreddayMovingAverage>(.*?)<\/TwoHundreddayMovingAverage>/){$twohundreddayave = $1;}
if ($content =~ /<MarketCapitalization>(.*?)<\/MarketCapitalization>/){$mktcap = $1;}
if ($content =~ /<PERatio>(.*?)<\/PERatio>/){$pe = $1;}

print  out "$ticker,$close_prc,$curncy,$lt_time,$eps,$yearlow,$yearhigh,$prevclose,$oneyrtarget,$vol,$fiftydayave,$twohundreddayave,$pe,$mktcap\n";
}
close (F);
close (out);
1;
