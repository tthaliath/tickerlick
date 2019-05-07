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
&getResults('AAPL');
sub getResults
{
my ($ticker) = uc shift;
my %tickerhash = {};
my ($lasttrade,$curncy,$lt_time,$eps,$yearlow,$yearhigh,$prevclose,$oneyrtarget,$vol,$fiftydayave,$twohundreddayave,$pe,$mktcap) = "";;
my $rtqstr = get ("http://finance.google.com/finance/info?client=ig&q=$ticker");
my $content = get("http://query.yahooapis.com/v1/public/yql?q=select%20%2a%20from%20yahoo.finance.quotes%20where%20symbol%20in%20%28%22".$ticker."%22%29&env=store://datatables.org/alltableswithkeys");
$rtqstr =~ s/\n/ /g;
print "$rtqstr\n";
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


if ($content =~ /<Currency>(.*?)<\/Currency>.*?<LastTradeDate>(.*?)<\/LastTradeDate>.*?<EarningsShare>(.*?)<\/EarningsShare>.*?<YearLow>(.*?)<\/YearLow>.*?<YearHigh>(.*?)<\/YearHigh>.*?<MarketCapitalization>(.*?)<\/MarketCapitalization>.*?<PreviousClose>(.*?)<\/PreviousClose>.*?<PERatio>(.*?)<\/PERatio>.*?<OneyrTargetPrice>(.*?)<\/OneyrTargetPrice>.*?<Volume>(.*?)<\/Volume>.*?<DividendYield>(.*?)<\/DividendYield>/)
{
    $tickerhash{curncy} = $1;
    $tickerhash{lttime} = $2;
    $tickerhash{eps} = $3;
    $tickerhash{yearlow} = $4;
    $tickerhash{yearhigh} = $5;
    $tickerhash{prevclose} = $7;
    $tickerhash{oneyrtarget} = $9;
    $tickerhash{vol} = $10;
    $tickerhash{mktcap} = $6;
    $tickerhash{pe} = $8;
    $tickerhash{divyield} = $11;
}
  
#print  "$ticker,$lasttrade,$curncy,$lt_time,$eps,$yearlow,$yearhigh,$prevclose,$oneyrtarget,$vol,$fiftydayave,$twohundreddayave,$pe,$mktcap\n";
   $tickerhash{ticker} = $ticker;
   $lasttrade = $tickerhash{lasttrade};
    if ($tickhash{invalidticker}) {return undef;}
        $wkRange = $tickerhash{yearlow} ."-".$tickerhash{yearhigh};
        $tickerhash{wkRange} = $wkRange;

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
#my $lasttrade = $tickerhash{LastTrade};
$dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
 $sql = "select ticker_id,comp_name,sector,industry from tickermaster where ticker = '$ticker'";
#print "tom1:$sql\n";
  $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array) {
  $ticker_id = $row[0];
  $tickerhash{name} = $row[1];
  $tickerhash{sector} = $row[2];
  $tickerhash{industry} = $row[3];
}
if (!$ticker_id)
{
 $tickerhash{dma10} = "N\/A";
 $tickerhash{dma50} = "N\/A";
 $tickerhash{dma200} = "N\/A";
 next;
}
 $sql ="select dma_10, dma_50, dma_200 from tickerprice a where a.ticker_id = $ticker_id ORDER BY a.price_date DESC LIMIT 0,1;";
#print "tom2:$sql\n";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array)
 {
  $tickerhash{dma10} = $row[0] || "N\/A";
  $tickerhash{dma50} = $row[1] || "N\/A";
  $tickerhash{dma200} = $row[2] || "N\/A";
  $flag = 1;
}
 $sth->finish;
 if (!$flag)
{
 $tickerhash{dma10} = "N\/A";;
 $tickerhash{dma50} = "N\/A";
 $tickerhash{dma200} = "N\/A";
}
else
{
 $tickerhash{dma10diff} = abs(sprintf("%.2f", $tickerhash{dma10} - $lasttrade));
 if ($tickerhash{dma10}  && $tickerhash{dma10} > 0)
{
 $tickerhash{dma10diffper} = abs(sprintf("%.2f",($tickerhash{dma10diff}/$tickerhash{dma10}) * 100));
}
 $tickerhash{dma50diff} = abs(sprintf("%.2f", $tickerhash{dma50} - $lasttrade));
 if ($tickerhash{dma50}  && $tickerhash{dma50} > 0)
{
 $tickerhash{dma50diffper} = abs(sprintf("%.2f",($tickerhash{dma50diff}/$tickerhash{dma50}) * 100));
}
 $tickerhash{dma200diff} = abs(sprintf("%.2f", $tickerhash{dma200} - $lasttrade));
if ($tickerhash{dma200} && $tickerhash{dma200} > 0)
{
 $tickerhash{dma200diffper} = abs(sprintf("%.2f",($tickerhash{dma200diff}/$tickerhash{dma200}) * 100));
}
 if ($tickerhash{dma10} < $lasttrade)
 {
  $tickerhash{dma10stat} = "up";
 }
 else
 {
  $tickerhash{dma10stat} = "down";
 }
if ($$tickerhash{dma50} < $lasttrade)
 {
  $$tickerhash{dma50stat} = "up";
 }
 else
 {
  $$tickerhash{dma50stat} = "down";
 }
 if ($$tickerhash{dma200} < $lasttrade)
 {
  $$tickerhash{dma200stat} = "up";
 }
 else
 {
  $$tickerhash{dma200stat} = "down";
 }
}
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
  my $resulthtml  = '<table border="1" cellpadding="1" cellspacing="1" width="70%" align="center">';
 $resulthtml  .= '<tr bgcolor="#00FFFF"><th colspan=12>MACD Signal and Crossover Data for the last 50 days</th></tr>';
 $resulthtml  .= '<tr bgcolor="#00FFFF"><th colspan=2>Price History</th><th colspan=5>MACD(12,26,9) Signal and Crossover Data for the last 50 days</th><th colspan=5>MACD(5,35,5) Signal and Crossover Data for the last 50 days</th></tr>';
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
        $arrcrossover[$rowprev2] = "<td>$crossoverhash{$signallast2}</td></tr>";
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
        $arrcrossover[0] = "<td>$crossoverhash{'nochange'}</td>";
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

1;
