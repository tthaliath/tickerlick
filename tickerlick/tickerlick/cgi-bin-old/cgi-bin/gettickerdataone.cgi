#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath
#Program File: search.pl
#Date started : 06/24/03
#Last Modified : 11/07/03
#Purpose : Display the search result for the terms entered by user
use lib qw(/home/tickerlick/cgi-bin);
use lib qw(/home/tickerlick/Tickermain);
$| = 1;
use strict;
use CGI;
use TickerDB;
my ($q) = new CGI;
my (@locarr,$location,$querytext,$offset,$catid,$pagetype,$row_count,$l,$keypat,@lindexarr,$res_count);
my ($size,$nolinks,$sortby,$keycnt,$query_option);

#use ISTR::Search;
#my ($SEARCH) = ISTR::Search->new();
require "gettickerdet.pl";
require "updatetickerpricedata.pl";
print "Content-type:text/html\n\n";

#print header;
#get all the form variable values
#my (@locarr) = $q->param("l");
#foreach (@locarr){print "location:$_<br>";}
$querytext = $q->param("q");
my ($documentBuffer1) = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script language="javascript" type="text/javascript">
function setFocus(){document.f.q.focus();}
function submitForm(obj ) {
    var l = obj
	var len = document.f.l.options.length
	if (l.value == "Search" )
	{
	   document.f.lindex.value = len
	   document.f.action = "/cgi-bin/gettickerdataone.cgi";
	   document.f.submit();
	   return true;
	 }

}
</script>
<link rel="stylesheet" href="http://tickerlick.com/common/ishtaar.css" type="text/css">


</head>
<body leftmargin="0" topmargin="0" marginheight="0" marginwidth="0" link=#0000cc vlink=#551a8b alink=#ff0000 onLoad="locationDropPageLoad(document.f.c,document.f.l);">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr><td>

<table align="center">
  <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=10></td></tr>
  <tr>
		<tr>
        <td height="25" class="companytext" ><font color="#05840C">TICKER</font><font color="#FA3205">LICK</font>
        </td>

  </tr>
   <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=10></td></tr>
   </table>
       <form  name=f METHOD=GET action="/cgi-bin/gettickerdataone.cgi">
      <table  align="center">

        <tr>
          <td height="23" class="bluetext">Enter Ticker</td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=10></td>
          <td ><input type="text" name="q" size="35" maxlength="255" value=""></td>
          <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11></td>
          <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11></td>
          <td><input type="submit" name="s" value="Search"> </td>
        </tr>
        <tr>
          <td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td>
        </tr>
      </table><br>
</form>
</tr></td></table>'; 
print $documentBuffer1;
my %tickerhash = getResults($querytext);
#my $resulthtml = '<iframe align="middle" height="400" frameborder="0">';
my $resulthtml  .= '<table border="1" cellpadding="1" cellspacing="1" width="70%" align="center">';
if (!$tickerhash{Ticker})
{
   $resulthtml .= "<tr><td><table><tr><td>Ticker $querytext is invalid or insufficienty trading data. Please check the Ticker.</td></tr></table></td></tr></table>";
}
else
{
#technical analysis data
my $charthtml .= "<tr><td><table><tr><td>Last price ".$tickerhash{PriceStat}." ".$tickerhash{pricediff}." from previous day close. Last price ".$tickerhash{difflowstat}." ".$tickerhash{perdifflow}."\% from 52 week low and ".$tickerhash{diffhighstat}." ".$tickerhash{perdiffhigh}."\% from 52 week high. ";
if ($tickerhash{dma10} ne "N\/A")
{
  $charthtml .= "10 Day moving average is ".$tickerhash{dma10stat}." ".$tickerhash{dma10diff}." from last price\. ";
}
if ($tickerhash{dma50} ne "N\/A")
{
 $charthtml .= "50 Day moving average is ".$tickerhash{dma50stat}." ".$tickerhash{dma50diff}." from last price\. ";
}
if ($tickerhash{dma200} ne "N\/A")
{
 $charthtml .= " 200 Day moving average is ".$tickerhash{dma200stat}." ".$tickerhash{dma200diff}." from last price\.";
}
$charthtml .= "</td></tr></table></td></tr>";
if ($tickerhash{class} eq 'ETF')
{
$resulthtml .= $charthtml; 
  $resulthtml .= "<tr><td><table><tr><td>Ticker&nbsp;:&nbsp$tickerhash{Ticker}</td><td>Name&nbsp;:&nbsp$tickerhash{name}</td></tr></table></td></tr><tr><td>
<table><tr><td>Last Trade&nbsp;:&nbsp$tickerhash{LastTrade}</td><td>Prev Close&nbsp;:&nbsp$tickerhash{PrevClose}</td><td>Volume&nbsp;:&nbsp$tickerhash{vol}</td></tr><tr><td>Nav&nbsp;:&nbsp$tickerhash{Nav}</td><td>52 Week Range&nbsp;:&nbsp$tickerhash{wkRange}</td><td>Yield&nbsp;:&nbsp$tickerhash{DivYield}</td></tr>
<tr><td>10 Day Moving Average&nbsp;:&nbsp$tickerhash{dma10}</td><td>50 Day Moving Average&nbsp;:&nbsp$tickerhash{dma50}</td><td>200 Day Moving Average&nbsp;:&nbsp$tickerhash{dma200}</td></tr></table>
</td></tr></table>";
}
else
{
 $resulthtml .= $charthtml;
 $resulthtml .= "<tr><td><table><tr><td>Ticker&nbsp;:&nbsp$tickerhash{Ticker}</td><td>Name&nbsp;:&nbsp$tickerhash{name}</td><td>Sector&nbsp;:&nbsp$tickerhash{sector}</td><td>Industry&nbsp;:&nbsp$tickerhash{industry}</td></tr></table>
</td></tr><tr><td>
<table><tr><td>Last Trade&nbsp;:&nbsp$tickerhash{LastTrade}</td><td>Prev Close&nbsp;:&nbsp$tickerhash{PrevClose}</td><td>Volume&nbsp;:&nbsp$tickerhash{vol}</td><td>1 Year Target Est&nbsp;:&nbsp$tickerhash{yTargetEst}</td></tr>
<tr><td>52 Week Range&nbsp;:&nbsp$tickerhash{wkRange}</td></tr>
</table>
</td></tr><tr><td>
<table>
<tr><td>PE&nbsp;:&nbsp$tickerhash{PE}</td><td>Forward PE&nbsp;:&nbsp$tickerhash{ForwardPE}</td><td>EPS&nbsp;:&nbsp$tickerhash{EPS}</td></tr>
<tr><td>Market Cap&nbsp;:&nbsp$tickerhash{MarketCap}</td><td>Beta&nbsp;:&nbsp$tickerhash{Beta}</td></tr>
<tr><td>10 Day Moving Average&nbsp;:&nbsp$tickerhash{dma10}</td><td>50 Day Moving Average&nbsp;:&nbsp$tickerhash{dma50}</td><td>200 Day Moving Average&nbsp;:&nbsp$tickerhash{dma200}</td></tr>
<tr><td>Enterprise Value&nbsp;:&nbsp$tickerhash{EnterpriseValue}</td><td>Enterprise Value\/Revenue&nbsp;:&nbsp$tickerhash{EnterpriseValueRevenue}</td><td>Enterprise Value\/EBITDA&nbsp;:&nbsp$tickerhash{EnterpriseValueEBITDA}</td></tr>
</table>

</td></tr><tr><td>

<table>
<tr><td>Revenue&nbsp;:&nbsp$tickerhash{Revenue}</td><td>Qtrly Revenue Growth&nbsp;:&nbsp$tickerhash{QtrlyRevenueGrowth}</td><td>Revenue\/share&nbsp;:&nbsp$tickerhash{RevenuePerShare}</td></tr>
<tr><td>PEG Ratio&nbsp;:&nbsp$tickerhash{PEGRatio}</td><td>Price\/Sales&nbsp;:&nbsp$tickerhash{PriceSales}</td><td>Price\/Book&nbsp;:&nbsp$tickerhash{PriceBook}</td></tr>
<tr><td>Operating Margin&nbsp;:&nbsp$tickerhash{OperatingMargin}</td><td>Return On Assets&nbsp;:&nbsp$tickerhash{ReturnonAssets}</td><td>Return On Equity&nbsp;:&nbsp$tickerhash{ReturnonEquity}</td></tr>
<tr><td>Total Cash&nbsp;:&nbsp$tickerhash{TotalCash}</td><td>Total Cash\/Share&nbsp;:&nbsp$tickerhash{TotalCashPerShare}</td><td>Total Debt&nbsp;:&nbsp$tickerhash{TotalDebt}</td><td>TotalDebt\/Equity&nbsp;:&nbsp$tickerhash{TotalDebtEquity}</td></tr>
<tr><td>Current Ratio&nbsp;:&nbsp$tickerhash{CurrentRatio}</td><td>Book Value\/Share&nbsp;:&nbsp$tickerhash{BookValuePerShare}</td><td>Operating Cash Flow&nbsp;:&nbsp$tickerhash{OperatingCashFlow}</td><td>Levered Free Cash Flow&nbsp;:&nbsp$tickerhash{LeveredFreeCashFlow}</td></tr>
</table>

</td></tr><tr><td>

<table>
<tr><td>Shares Outstanding&nbsp;:&nbsp$tickerhash{SharesOutstanding}</td><td>Shares Short&nbsp;:&nbsp$tickerhash{SharesShort}</td></tr>

<tr><td>Ex Dividend Date&nbsp;:&nbsp$tickerhash{exdividenddate}</td><td>Div Yield&nbsp;:&nbsp$tickerhash{DivYield}</td><td>Payout Ratio&nbsp;:$tickerhash{PayoutRatio}</td></tr>

</table>

</td></tr></table>";
}
}
print $resulthtml;
#print historical price and DMA

if ($tickerhash{Ticker})
{
  my $ticker_id = getTickerID($tickerhash{Ticker});
  updatecurrentprice($ticker_id,$tickerhash{LastTrade});
  my $pricehistoryhtml = &getpricehistory($ticker_id,50);
  print "$pricehistoryhtml\n";
}
print "<\iframe>\n";

if ($tickerhash{class} eq 'ETF')
{
my $framehtml = '<iframe align="middle" height="250" frameborder="0"></iframe>';
print "$framehtml\n";
}
my $documentBuffer2 = '<table align="center">
  <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=20></td></tr>
  <tr>
        <td>
                <a href="http://www.tickerlick.com/index.html">Home</a>
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
