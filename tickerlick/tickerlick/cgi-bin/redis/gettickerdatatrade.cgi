#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath
#Program File: search.pl
#Date started : 06/24/03
#Last Modified : 11/07/03
#Purpose : Display the search result for the terms entered by user
use lib qw(/home/tickerlick/cgi-bin);
use lib qw(/home/tickerlick/Tickermain);
BEGIN { chdir('/home/tickerlick/cgi-bin'); }
$| = 1;
use strict;
use CGI;
use TickerDB;
my ($q) = new CGI;
my (@locarr,$location,$querytext,$offset,$catid,$pagetype,$row_count,$l,$keypat,@lindexarr,$res_count,$resulthtml,$result2html,$macdhtml,$charthtml,$framehtml);
my ($size,$nolinks,$sortby,$keycnt,$query_option);
my ($rep_type,$title,$query,$dbh,$sth,@row);
#use ISTR::Search;
#my ($SEARCH) = ISTR::Search->new();
require "gettickerdettrade.pl";
require "updatetickerpricedata_trade.pl";
print "Content-type:text/html\n\n";

#print header;
#get all the form variable values
#my (@locarr) = $q->param("l");
#foreach (@locarr){print "location:$_<br>";}
$querytext = $q->param("q");
my ($documentBuffer1) = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
<title>TICKERLICK - Real time buy and sell signals based on technical indicators</title> 
<meta name="keywords" lang="en-US" content="MACD, Stochastic, RSI, Oversold, Overbought, Stock Research, Investment Tools"/>
<script language="javascript" type="text/javascript">
function setFocus(){document.f.q.focus();}
function submitform(obj ) {
    var l = obj
           var s = l.q.value.split(" ");
           l.q.value = s[0];
           document.f.action = "/cgi-bin/gettickerdatatrade.cgi";
           document.f.submit();
           return true;

}
</script>
<script>
function submitform2(obj,reptype) {
           var r = obj
           r.s.value = reptype;
           document.r.action = "/cgi-bin/gettickerdatatrade.cgi";
           document.r.submit();
           return true;

}
</script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">

  <script src="//code.jquery.com/jquery-1.10.2.js"></script>

  <script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>


<script>

  $(function() {

    var cache = {};

    $( "#symbols" ).autocomplete({

      minLength: 2,

      source: function( request, response ) {

        var term = request.term;

        if ( term in cache ) {

          response( cache[ term ] );

          return;

        }



        $.getJSON( "/searchsymbol.php", request, function( data, status, xhr ) {

          cache[ term ] = data;
          response( data );

        });

      }

    });

  });

  </script>
</head>
<body leftmargin="0" topmargin="0" marginheight="0" marginwidth="0" link=#0000cc vlink=#551a8b alink=#ff0000 >
<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr><td>
  <table align="center">
  <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td></tr>
  <tr>
		<tr>
        <td height="25" class="companytext" ><font color="#05840C">TICKER</font><font color="#FA3205">LICK</font>
        </td>

  </tr>
   <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=10></td></tr>
   </table>
   <table align="center">
  <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=10></td></tr>
   <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=10></td></tr>
   </table>
       <form  name=f METHOD=GET action="/cgi-bin/gettickerdatatrade.cgi">
      <table  align="center">

        <tr>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=10></td>
          <td><div class="ui-widget">

             <label for="symbols">Symbol: </label>

             <input id="symbols" name="q">
            </div></td>
          <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11></td>
          <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11></td>
          <td><button onclick="submitform(f)">Search</button></td>
        </tr>
        <tr>
          <td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td>
        </tr>
      </table><br>
</form>
</tr></td></table>
<form  name=r METHOD=GET action="/cgi-bin/gettickerdatatrade.cgi">
<input type="hidden" name="s">
<table align="center">
<tr>
        <td>
               <button value="mbu"  onclick="submitform2(r,\'mbu\')" >MACD Bullish Crossover</button>
        </td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>    <button value="mbe"  onclick="submitform2(r,\'mbe\')" >MACD Bearish Crossover</button>
        </td>
        </tr>
        <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td></tr>
        </td>

</tr>
<tr>
        <td> <button value="os" onclick="submitform2(r,\'os\')" >MACD Oversold (Bullish)</button></td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>    <button value="ob" onclick="submitform2(r,\'ob\')" >MACD Overbought (Bearish)</button>
        </td>
        </tr>
        <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td></tr>
        </td>

  </tr>
  <tr>
        <td>
                <button value="rs" onclick="submitform2(r,\'rs\')" >RSI Oversold (Bullish)</button>
        </td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>    <button value="rb" onclick="submitform2(r,\'rb\')" >RSI Overbought (Bearish)</button>
        </td>
        </tr>

        <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td></tr>
        </td>
  </tr>
   <tr>
        <td>
                <button value="ss" onclick="submitform2(r,\'ss\')" >Stochastic Oversold (Bullish)</button>

        </td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>    <button value="sb" onclick="submitform2(r,\'sb\')" >Stochastic Overbought (Bearish)</button>
        </td>
        </tr>

        <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td></tr>
        </td>

  </tr>
   <tr>
        <td>
                <button value="ss" onclick="submitform2(r,\'ef\')" >Equity Fundamental</button>

        </td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>    <button value="sb" onclick="submitform2(r,\'nf\')" >ETF/ETN/Funds Fundamental</button>
        </td>
        </tr>

        <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td></tr>
        </td>

  </tr>
  </table></form>'; 
print $documentBuffer1;
#if it is a request to print reports, please ignore ticker value ($q->param("q")
if (defined($q->param("s")))
{
 $rep_type = $q->param("s"); 
 $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
 if ($rep_type eq 'os')
{
    $title = "MACD (5,35,5) Oversold (Bullish)";
    $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'OS' and b.ticker_id = a.ticker_id and a.tflag = 'Y' order by sector";
     }
elsif ($rep_type eq 'ob')
{
     $title = "MACD (5,35,5) Overbought (Bullish)";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'OB' and b.ticker_id = a.ticker_id and a.tflag = 'Y' order by sector";
     }
elsif ($rep_type eq 'rs')
{
     $title = "RSI Oversold (Bullish)";
     $query = "select ticker, comp_name,sector, industry from tickermaster a, report b where report_flag in ('RS') and a.ticker_id = b.ticker_id and a.tflag = 'Y' order by sector";
}
elsif ($rep_type eq 'rb')
{
     $title = "RSI Overbought (Bearish)";
     $query = "select ticker, comp_name,sector, industry from tickermaster a, report b where report_flag in ('RB') and a.ticker_id = b.ticker_id and a.tflag = 'Y' order by sector";
}
elsif ($rep_type eq 'ss')
{
     $title = "Stochastic Oversold (Bullish)";
     $query = "select ticker, comp_name,sector, industry from tickermaster a, report b where report_flag in ('SS') and a.ticker_id = b.ticker_id  and a.tflag = 'Y' order by sector";
}
elsif ($rep_type eq 'sb')
{
     $title = "Stochastic Overbought (Bearish)";
     $query = "select ticker, comp_name,sector, industry from tickermaster a, report b where report_flag in ('SB') and a.ticker_id = b.ticker_id and a.tflag = 'Y' order by sector";
}
elsif ($rep_type eq 'mbu')
{
     $title = "MACD Bullish Crossover";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'MBU' and b.ticker_id = a.ticker_id and a.tflag = 'Y' order by sector";
}
elsif ($rep_type eq 'mbe')
{
     $title = "MACD Bearish Crossover";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'MBE' and b.ticker_id = a.ticker_id and a.tflag = 'Y' order by  sector";
}
elsif ($rep_type eq 'vbe')
{
     $title = "Vey Bearish";
     $query = "SELECT a.ticker,a.comp_name,sector,industry from tickermaster a, (select ticker_id,count(*) from report where report_flag in ('SB','RB','OB','MBE') group by ticker_id having count(*) > 2) ab where a.ticker_id = ab.ticker_id and a.tflag = 'Y'";
}
elsif ($rep_type eq 'vbu')
{
     $title = "Vey Bullish";
     $query = "SELECT a.ticker,a.comp_name,sector,industry from tickermaster a, (select ticker_id,count(*) from report where report_flag in ('SS','RS','OS','MBU') group by ticker_id having count(*) > 2) ab where a.ticker_id = ab.ticker_id and a.tflag = 'Y'";
}
elsif ($rep_type eq 'ef')
{
     $title = "Equity Fundamental";
     $query = "select ticker,comp_name,sector,industry,pegratio,operatingcashflow,sharesoutstanding,divyield,wkrange,qtrlyrevenuegrowth,marketcap,weekchange,prevclose,lasttrade,payoutratio,enterprisevalueebitda,grossprofit,trailingpe,enterprisevalue,dma200,totalcashpershare,operatingmargin,pricesales,pricestat,revenuepershare,beta,weeklow,netincomeavltocommon,sharesshort,pe,qtrlyearningsgrowth,enterprisevaluerevenue,pricebook,sp50052weekchange,totaldebtequity,nav,returnonassets,dilutedeps,pricediff,revenue,exdividenddate,returnonequity,totaldebt,leveredfreecashflow,yearlow,weekhigh,dma10,forwardpe,dma50,ytargetest,ebitda,yearhigh,twohundreddaymovingaverage,currentratio,eps,bookvaluepershare,fiftydaymovingaverage,totalcash from secmaster a, tickermaster b where a.ticker_id = b.ticker_id and b.tflag = 'Y' and marketcap > 250000000 and pe > 0 and class = 'Common Stock' order by eps desc limit 200";
}
elsif ($rep_type eq 'nf')
{
     $title = "ETF/ETN/Fund Fundamental";
     $query = "select ticker,comp_name,sector,industry,class,pegratio,operatingcashflow,sharesoutstanding,divyield,wkrange,qtrlyrevenuegrowth,marketcap,weekchange,prevclose,lasttrade,payoutratio,enterprisevalueebitda,grossprofit,trailingpe,enterprisevalue,dma200,totalcashpershare,operatingmargin,pricesales,pricestat,revenuepershare,beta,weeklow,netincomeavltocommon,sharesshort,pe,qtrlyearningsgrowth,enterprisevaluerevenue,pricebook,sp50052weekchange,totaldebtequity,nav,returnonassets,dilutedeps,pricediff,revenue,exdividenddate,returnonequity,totaldebt,leveredfreecashflow,yearlow,weekhigh,dma10,forwardpe,dma50,ytargetest,ebitda,yearhigh,twohundreddaymovingaverage,currentratio,eps,bookvaluepershare,fiftydaymovingaverage,totalcash from secmaster a, tickermaster b where a.ticker_id = b.ticker_id and b.tflag = 'Y' and pe > 0 and class != 'Common Stock' order by pe desc limit 200";
}
 print '<table border="1" cellpadding="1" cellspacing="1" width="70%" align="center">';
 if ($rep_type ne 'ef' && $rep_type ne 'nf')
   {
    print  '<tr bgcolor="#00FFFF"><th colspan=4>'.$title.'</th></tr>';
    print "<tr><td>Symbol</td><td>Security Name</td><td>Sector</td><td>Industry</td></tr>";
   }
 elsif ($rep_type eq 'ef')
   { 
     print  '<tr bgcolor="#00FFFF"><th colspan=17>'.$title.'</th></tr>';
    print "<tr><td>Symbol</td><td>Security Name</td><td>Sector</td><td>Industry</td><td>pegratio</td><td>operatingcashflow</td><td>sharesoutstanding</td><td>divyield</td><td>wkrange</td><td>qtrlyrevenuegrowth</td><td>marketcap</td><td>weekchange</td><td>prevclose</td><td>lasttrade</td><td>PE</td><td>FPE</td><td>EPS</td></tr>";
   }
  else
  {
     print  '<tr bgcolor="#00FFFF"><th colspan=17>'.$title.'</th></tr>';
    print "<tr><td>Symbol</td><td>Security Name</td><td>Sector</td><td>Industry</td><td>Sectype</td><td>pegratio</td><td>operatingcashflow</td><td>sharesoutstanding</td><td>divyield</td><td>wkrange</td><td>qtrlyrevenuegrowth</td><td>marketcap</td><td>weekchange</td><td>prevclose</td><td>lasttrade</td><td>PE</td><td>NAV</td></tr>";
   }
 $sth = $dbh->prepare($query);  
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array)
 {
   if ($rep_type ne 'ef' && $rep_type ne 'nf')
   {
     print "<tr><td>";
     print "<a href=http://www.tickerlick.com/cgi-bin/gettickerdatatrade.cgi?q=".$row[0].">".$row[0]."</a></td><td>" . $row[1] ."</td><td>". $row[2] ."</td><td>". $row[3];
     print "</td></tr>";
   }
   elsif ($rep_type eq 'ef')
   {
      print "<tr><td>";
      print "<a href=http://www.tickerlick.com/cgi-bin/gettickerdatatrade.cgi?q=".$row[0].">".$row[0]."</a></td><td>" . $row[1] ."</td><td>". $row[2] ."</td><td>". $row[3]."</td><td>". $row[4]."</td><td>". $row[5]."</td><td>". $row[6]."</td><td>". $row[7]."</td><td>". $row[8]."</td><td>". $row[9]."</td><td>". $row[10]."</td><td>". $row[11]."</td><td>". $row[12]."</td><td>". $row[13]."</td><td>". $row[29]."</td><td>".$row[47]."</td><td>".$row[54]; 
     print "</td></tr>";
   }
   else
   {
     print "<tr><td>";
     print "<a href=http://www.tickerlick.com/cgi-bin/gettickerdatatrade.cgi?q=".$row[0].">".$row[0]."</a></td><td>" . $row[1] ."</td><td>". $row[2] ."</td><td>". $row[3]."</td><td>". $row[4]."</td><td>". $row[5]."</td><td>". $row[6]."</td><td>". $row[7]."</td><td>". $row[8]."</td><td>". $row[9]."</td><td>". $row[10]."</td><td>". $row[11]."</td><td>". $row[12]."</td><td>". $row[13]."</td><td>". $row[30]."</td><td>". $row[36];
    print "</td></tr>";
   }
 }
 print "</table>";
 $sth->finish();
}
else
{
#my ($remote_addr) = $ENV{REMOTE_ADDR};
#print "$remote_addr\n";

my %tickerhash = getResults($querytext);
#my $resulthtml = '<iframe align="middle" height="400" frameborder="0">';
my $tophtml  .= '<table border="1" cellpadding="1" cellspacing="1" width="70%" align="center">';
#print "ddddddd:$tickerhash{invalidticker}\n";
if ($tickerhash{invalidticker})
{
   $tophtml .= "<tr><td><table align=\"center\"><tr><td>Ticker <strong>$querytext</strong> is invalid or insufficient trading or company data. Please check the Ticker.</td></tr></table></td></tr></table>";
print  "$tophtml\n";
$framehtml = '<iframe align="middle" height="250" frameborder="0"></iframe>';
 print "$framehtml\n";
}
else
{
my $tickid = $tickerhash{Ticker};
if ($tickerhash{class} eq 'ETF')
{
#$resulthtml .= $charthtml; 
  $tophtml .= "<tr><td><table><tr><td>Ticker&nbsp;:&nbsp;$tickerhash{Ticker}</td><td>Name&nbsp;:&nbsp;$tickerhash{name}</td></tr></table></td></tr>";

$result2html .= "<tr><td><table><tr><td>Last Trade&nbsp;:&nbsp;$tickerhash{LastTrade}</td><td>Prev Close&nbsp;:&nbsp;$tickerhash{PrevClose}</td><td>Volume&nbsp;:&nbsp;$tickerhash{vol}</td></tr><tr><td>Nav&nbsp;:&nbsp;$tickerhash{Nav}</td><td>52 Week Range&nbsp;:&nbsp;$tickerhash{wkRange}</td><td>Yield&nbsp;:&nbsp;$tickerhash{DivYield}</td></tr></table></td></tr>";
}
else
{
 #$resulthtml .= $charthtml;
 $tophtml .= "<tr><td><table><tr><td>Ticker&nbsp;:&nbsp$tickerhash{Ticker}</td><td>Name&nbsp;:&nbsp$tickerhash{name}</td><td>Sector&nbsp;:&nbsp$tickerhash{sector}</td><td>Industry&nbsp;:&nbsp$tickerhash{industry}</td></tr></table></td></tr>";
$result2html = "<tr><td><table><tr><td>Last Trade&nbsp;:&nbsp$tickerhash{LastTrade}</td><td>Prev Close&nbsp;:&nbsp$tickerhash{PrevClose}</td><td>Volume&nbsp;:&nbsp$tickerhash{vol}</td><td>1 Year Target Est&nbsp;:&nbsp$tickerhash{yTargetEst}</td></tr><tr><td>52 Week Range&nbsp;:&nbsp$tickerhash{wkRange}</td></tr></table></td></tr>";
}
#technical analysis data
$charthtml = $tophtml.'<tr><td><table><tr><td rowspan="2"><p align="justify"><b><font color="#000000" size="+2">'.$tickerhash{LastTrade}.'</font>';

if ($tickerhash{PriceStat} eq  "up")
{
  $charthtml .= '<img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><img src="http://tickerlick.com/images/up_g.gif" height=20><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><font color="#05840C" size="+2">'.$tickerhash{pricediff}.' ('.$tickerhash{pricediffper}.'%)</font> from previous day  close.';
}
else
{
  $charthtml .= '<img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><img src="http://tickerlick.com/images/down_r.gif" height=20><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><font color="#FF0000" size="+2">'.$tickerhash{pricediff}.' ('.$tickerhash{pricediffper}.'%)</font> from previous day  close.';
}

if ($tickerhash{difflowstat} eq "up")
{

  $charthtml .= '<img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><img src="http://tickerlick.com/images/up_g.gif" height=20><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><font color="#05840C" size="+2">'.$tickerhash{difflow}.' ('.$tickerhash{perdifflow}.'%)</font> from 52 week low.';
}
else
{
  $charthtml .= '<img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><img src="http://tickerlick.com/images/down_r.gif" height=20><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><font color="#FF0000" size="+2">'.$tickerhash{difflow}.' ('.$tickerhash{perdifflow}.'%)</font> from 52 week low.';
}
  
if ($tickerhash{diffhightstat} eq "up")
{

  $charthtml .= '<img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><img src="http://tickerlick.com/images/up_g.gif" height=20><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><font color="#05840C" size="+2">'.$tickerhash{diffhigh}.' ('.$tickerhash{perdiffhigh}.'%)</font> from 52 week high.';
}
else
{
  $charthtml .= '<img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><img src="http://tickerlick.com/images/down_r.gif" height=20><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><font color="#FF0000" size="+2">'.$tickerhash{diffhigh}.' ('.$tickerhash{perdiffhigh}.'%)</font> from 52 week high.';
}

if ($tickerhash{dma10} ne "N\/A")
{
  if ($tickerhash{dma10stat} eq "up")
  {
  
    $charthtml .= '<img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><img src="http://tickerlick.com/images/up_g.gif" height=20><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><font color="#05840C" size="+2">'.$tickerhash{dma10diff}.' ('.$tickerhash{dma10diffper}.'%)</font> from 10 Day moving average.';
  }
  else
  {
    $charthtml .= '<img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><img src="http://tickerlick.com/images/down_r.gif" height=20><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><font color="#FF0000" size="+2">'.$tickerhash{dma10diff}.' ('.$tickerhash{dma10diffper}.'%)</font> from 10 Day moving average.';
  }
}
 
 if ($tickerhash{dma50} ne "N\/A")
 {
   if ($tickerhash{dma50stat} eq "up")
   {
   
     $charthtml .= '<img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><img src="http://tickerlick.com/images/up_g.gif" height=20><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><font color="#05840C" size="+2">'.$tickerhash{dma50diff}.' ('.$tickerhash{dma50diffper}.'%)</font> from 50 Day moving average.';
   }
   else
   {
     $charthtml .= '<img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><img src="http://tickerlick.com/images/down_r.gif" height=20><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><font color="#FF0000" size="+2">'.$tickerhash{dma50diff}.' ('.$tickerhash{dma50diffper}.'%)</font> from 50 Day moving average.';
   }
  }
 
  if ($tickerhash{dma200} ne "N\/A")
  {
    if ($tickerhash{dma200stat} eq "up")
    {
    
      $charthtml .= '<img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><img src="http://tickerlick.com/images/up_g.gif" height=20><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><font color="#05840C" size="+2">'.$tickerhash{dma200diff}.' ('.$tickerhash{dma200diffper}.'%)</font> from 200 Day moving average.';
    }
    else
    {
      $charthtml .= '<img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><img src="http://tickerlick.com/images/down_r.gif" height=20><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11><font color="#FF0000" size="+2">'.$tickerhash{dma200diff}.' ('.$tickerhash{dma200diffper}.'%)</font> from 200 Day moving average.';
    }
  }
   
 #$charthtml .= "</td></tr></table></td></tr>";

#$resulthtml .= $charthtml;
$resulthtml .=$result2html; 
$resulthtml .= "<tr><td><table><tr><td>PE&nbsp;:&nbsp$tickerhash{PE}</td><td>Forward PE&nbsp;:&nbsp$tickerhash{ForwardPE}</td><td>EPS&nbsp;:&nbsp$tickerhash{EPS}</td></tr><tr><td>Market Cap&nbsp;:&nbsp$tickerhash{MarketCap}</td><td>Beta&nbsp;:&nbsp$tickerhash{Beta}</td></tr><tr><td>10 Day Moving Average&nbsp;:&nbsp$tickerhash{dma10}</td><td>50 Day Moving Average&nbsp;:&nbsp$tickerhash{dma50}</td><td>200 Day Moving Average&nbsp;:&nbsp$tickerhash{dma200}</td></tr>
</table>

</td></tr>

</table>";
}
#print $resulthtml;
#print historical price and DMA

if ($tickerhash{Ticker})
{
  my $ticker_id = getTickerID($tickerhash{Ticker});
  #if market opens, loadtoday's price too
  if (&marketlive())
   {
     updatecurrentprice($ticker_id,$tickerhash{LastTrade},$tickerhash{Ticker});
   }
    #print "111111GGGGGGGGG\n";
  #report flags if any
  my $rep_flag_html = "";
  my ($repflag);
  my %signalhash2 = &getSignal2($ticker_id);
  foreach my $repflag (keys  %signalhash2)
   {
      #print "<br> $ticker_id,$repflag\n";
      if ($repflag =~ /MS|SS|RS/)
      {
        $rep_flag_html .= '<br>'.$signalhash2{$repflag}.':<font color="#05840C" size="+2">Bullish</font>.';
      }
      else
      {
        $rep_flag_html .= '<br>'.$signalhash2{$repflag}.':<font color="#FF0000" size="+2">Bearish</font>';
      }
  }
  my %signalhash = &getSignal($ticker_id,50);
  my $macdhtml = "";
  if ($signalhash{macd226})
   {  
     #print "$signalhash{macd226}\n";
     my ($signaldate,$signal) = split (/\t/,$signalhash{macd226});
   if ($signal eq "Buy")
   {

     $macdhtml .= '<br>Current MACD (12,26,9) Indicator is <font color="#05840C" size="+2">Bullish</font>. Last crossover was on <strong>'.$signaldate.'</strong>.';
   }
   else
   {
     $macdhtml .= '<br>Current MACD (12,26,9) Indicator is <font color="#FF0000" size="+2">Bearish</font>. Last crossover was on <strong>'.$signaldate.'</strong>.';
   }
 }
if ($signalhash{macd535})
   {  
     #print "$signalhash{macd535}\n"; 
     my ($signaldate,$signal) = split (/\t/,$signalhash{macd535});
   if ($signal eq "Buy")
   {

     $macdhtml .= '<br>Current MACD (5,35,5) Indicator is <font color="#05840C" size="+2">Bullish</font>. Last crossover was on <strong>'.$signaldate.'</strong>.';
   }
   else
   {
     $macdhtml .= '<br>Current MACD (5,35,5) Indicator is <font color="#FF0000" size="+2">Bearish</font>. Last crossover was on <strong>'.$signaldate.'</strong>.';
   }
}
   
  my $pricehistoryhtml = &getpricehistory($ticker_id,50); 
  $charthtml .= $rep_flag_html.$macdhtml."</td></tr></table></td></tr>";
  $resulthtml = $charthtml.$resulthtml;
  #print "<tr><td><table align=\"center\"><tr><td><IMG SRC=\"/cgi-bin/graphMACD1.cgi?tickid=$ticker_id\"></td><td><IMG SRC=\"/cgi-bin/graphMACD2.cgi?tickid=$ticker_id\"></td></tr></table></td></tr>";
  print "<tr><td><table align=\"center\"><tr><td><IMG SRC=\"/cgi-bin/graphMACD3.cgi?tickid=$ticker_id\"></td><td><IMG SRC=\"/cgi-bin/graphMACD4.cgi?tickid=$ticker_id\"></td></tr></table></td></tr>";
  print "<tr><td><table align=\"center\"><tr><td><IMG SRC=\"/cgi-bin/graphRSI.cgi?tickid=$ticker_id\"></td><td><IMG SRC=\"/cgi-bin/graphStoch.cgi?tickid=$ticker_id\"></td></tr></table></td></tr>";
  print "$resulthtml\n";
  print "$pricehistoryhtml\n";
}
}
#print "<\iframe>\n";

#if ($tickerhash{class} eq 'ETF')
#{
# $framehtml = '<iframe align="middle" height="250" frameborder="0"></iframe>';
# print "$framehtml\n";
#}
my $documentBuffer2 = '<table align="center">
  <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=20></td></tr>
  <tr>
        <td>
                <a href="http://www.tickerlick.com">Home</a>
                <a href="http://www.tickerlick.com/aboutus.htm">About Tickerlick.com</a>
                <a href="http://www.tickerlick.com/contactus.htm">Contact Us</a>
                <a href="http://www.tickerlick.com/disclaimer.htm">Disclaimer</a>
                </td>
        </tr>
                <tr>
        <td align="center"><font size=-2>&copy;2012 Tickerlick - All rights reserved.</font><p></p>
        </td>

  </tr>
   <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=10></td></tr>
   </table>
</body>
</html>';

print $documentBuffer2;
