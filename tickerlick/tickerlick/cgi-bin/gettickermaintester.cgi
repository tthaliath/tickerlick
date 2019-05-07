#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath
#Program File: search.pl
#Date started : 06/24/03
#Last Modified : 11/07/03
#Purpose : Display the search result for the terms entered by user
push(@INC, '/home/tickerlick/cgi-bin');
use lib qw(/home/tickerlick/cgi-bin);
use lib qw(/home/tickerlick/Tickermain);
BEGIN { chdir('/home/tickerlick/cgi-bin'); }
$| = 1;
use strict;
use warnings;
use CGI;
use TickerDB;
use Data::Dumper;
my ($q) = new CGI;
use CGI::Session;
my $cgi = new CGI;
my $session = CGI::Session->load($cgi) or die CGI::Session->errstr;
my $cookie_name='PHPSESSID'; 
my $session_name = $cgi->cookie($cookie_name);
my $session_name_dir =  '/var/lib/php/session/sess_'.$session_name;
local $/=undef;
  open FILE, $session_name_dir;
  my $line = <FILE>;
  close FILE;
$/ = 1;
my $userlogged = 0;
my $username = '';
my $documentBuffer11 = '';
my $documentBuffer1 = '';
if ($line =~ /\;usr_/)
{
   $userlogged = 1;
   if ($line =~ /.*?\"(.*?)\"/)
   {
     $username = $1;
   } 
}
my (@locarr,$location,$querytext,$offset,$catid,$pagetype,$row_count,$l,$keypat,@lindexarr,$res_count,$resulthtml,$result2html,$macdhtml,$charthtml,$framehtml);
my ($size,$nolinks,$sortby,$keycnt,$query_option);
my ($rep_type,$title,$query,$dbh,$sth,@row);
my ($pricehistoryhtml) = "";
#use ISTR::Search;
#my ($SEARCH) = ISTR::Search->new();
require "/home/tickerlick/cgi-bin/gettickerdetall.pl";
require "/home/tickerlick/cgi-bin/gettickerjsonsingle.pl";
require "/home/tickerlick/cgi-bin/updatetickerpricedata_new.pl";
print "Content-type:text/html\n\n";

#print header;
#get all the form variable values
#my (@locarr) = $q->param("l");
#foreach (@locarr){print "location:$_<br>";}
#$querytext = $q->param("q");
$querytext = 'AAPL';
$documentBuffer1 = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
<meta http-equiv="Expires" content="Mon, 26 Jul 1997 05:00:00 GMT">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-control" content="no-cache">
<title>TICKERLICK - Real time buy and sell signals based on technical indicators</title> 
<meta name="keywords" lang="en-US" content="MACD, Stochastic, Bollinger, RSI, Oversold, Overbought, Stock Research, Investment Tools, Thomas Thaliath"/>
<script language="javascript" type="text/javascript">
function setFocus(){document.f.q.focus();}
function submitform(obj ) {
    var l = obj
           var s = l.q.value.split(" ");
           l.q.value = s[0];
           document.f.action = "/cgi-bin/gettickermain2json.cgi";
           document.f.submit();
           return true;

}
</script>
<script>
function submitform2(obj,reptype) {
           var r = obj
           r.s.value = reptype;
           document.r.action = "/cgi-bin/gettickermain2json.cgi";
           document.r.submit();
           return true;

}
</script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">

  <script src="//code.jquery.com/jquery-1.10.2.js"></script>

  <script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>

  <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>

<link rel="stylesheet" href="http://tickerlick.com/common/ishtaarnew.css" type="text/css">
<link rel="stylesheet" href="http://tickerlick.com/common/tickerlick2.css" type="text/css">
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
<table border="0" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse;">
  <tr><td>
  <tr  align="right"><td>
  <ul>
  <li><a href="http://www.tickerlick.com">Home</a></li>
  <li><a href="http://www.tickerlick.com/aboutus.htm">About Tickerlick</a></li>
  <li>My Account<span class="arrow">&#9660;</span>
   <ul>';
   if (!$userlogged)
   {
     $documentBuffer1 .= '<li><a href="http://www.tickerlick.com/users/login.php">Sign In</a></li>';
   }
     $documentBuffer1 .= '<li><a href="http://www.tickerlick.com/users/ma.php">Manage Trade Signal Alerts</a></li>';
   if ($userlogged)
   {
      $documentBuffer1 .= '<li><a href="http://www.tickerlick.com/users/change-pwd.php">Change Password</a></li>
                          <li><a href="http://www.tickerlick.com/users/logout.php">Sign Out</a></li>';
   }
print $documentBuffer1;

$documentBuffer11 = '</ul></li>
 <li><a href="http://www.tickerlick.com/contactus.htm">Contact Us</a></li>
 <li><a href="http://www.tickerlick.com/disclaimer.htm">Disclaimer</a></li>
 </ul>
 </td></tr>
  <table align="center" style="border-collapse: collapse;">
  <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td></tr>
  <tr>
		<tr>
        <td height="25" class="companytext" ><font color="#05840C">TICKER</font><font color="#FA3205">LICK</font>
        </td>

  </tr>
   <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=10></td></tr>
   </table>
   <table align="center" style="border-collapse: collapse;">
  <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=10></td></tr>
   <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=10></td></tr>
   </table>
       <form  name=f METHOD=GET action="/cgi-bin/gettickermain2json.cgi">
      <table  align="center" style="border-collapse: collapse;">

        <tr>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=10></td>
          <td><div class="ui-widget">

             <label for="symbols">Symbol: </label>

             <input id="symbols" name="q">
            </div></td>
          <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11></td>
          <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=11></td>
          <td><button class="greenbutton" onclick="submitform(f)">Search</button></td>
        </tr>
        <tr>
          <td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td>
        </tr>
      </table><br>
</form>
</tr></td></table>';
print $documentBuffer11;
my $documentBuffer111 = '';
$documentBuffer111 = '<form  name=r METHOD=GET action="/cgi-bin/gettickermain2json.cgi">
<input type="hidden" name="s">
<table align="center" style="border-collapse: collapse;">';
#if ($userlogged)
#{
$documentBuffer111 .= '<tr>
        <td>
               <button class="greenbutton" value="xos"  onclick="submitform2(r,\'xos\')" >Extremely Oversold</button>
        </td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>   <button class="redbutton" value="xob"  onclick="submitform2(r,\'xob\')" >Extremely Overbought</button>
        </td>
        </tr>
        <tr><td height="3" style="line-height:0px; font-size:0px;">&nbsp;</td></tr>
        <tr>
        <td>
               <button value="mbux" class="greenbutton" onclick="submitform2(r,\'mbux\')" >S&P 500 - MACD Bullish Crossover</button>
        </td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td> <button value="osx" class="greenbutton" onclick="submitform2(r,\'osx\')" >S&P 500 - MACD Oversold (Bullish)</button></td>
        </td>
        </tr>
        <tr><td height="3" style="line-height:0px; font-size:0px;">&nbsp;</td></tr>
   <tr>
        <td>
                <button value="rsx" class="greenbutton" onclick="submitform2(r,\'rsx\')" >S&P 500 - RSI Oversold (Bullish)</button>
        </td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>   <button value="ssx" class="greenbutton" onclick="submitform2(r,\'ssx\')" >S&P 500 - Stochastic Oversold (Bullish)</button>
        </td>
        </tr>

   <tr>
        <td>
                <button value="bbux" class="greenbutton" onclick="submitform2(r,\'bbux\')" >S&P 500 - Bollinger Oversold (Bullish)</button>
        </td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>   <button value="ssx" class="greenbutton" onclick="submitform2(r,\'ssrx\')" >S&P 500 - Stochastic RSI Oversold (Bullish)</button>
        </td>
        </tr>
        <tr><td height="3" style="line-height:0px; font-size:0px;">&nbsp;</td></tr>
         <tr>
            <td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td>
        </tr>';
#}
$documentBuffer111 .= '<tr>
        <td>
               <button value="mbu"  class="greenbutton" onclick="submitform2(r,\'mbu\')" >MACD Bullish Crossover</button>
        </td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>    <button value="mbe" class="redbutton" onclick="submitform2(r,\'mbe\')" >MACD Bearish Crossover</button>
        </td>
        </tr>
        <tr><td height="3" style="line-height:0px; font-size:0px;">&nbsp;</td></tr>
<tr>
        <td> <button value="os" class="greenbutton" onclick="submitform2(r,\'os\')" >MACD Oversold (Bullish)</button></td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>    <button value="ob" class="redbutton" onclick="submitform2(r,\'ob\')" >MACD Overbought (Bearish)</button>
        </td>
        </tr>
        <tr><td height="3" style="line-height:0px; font-size:0px;">&nbsp;</td></tr>
  <tr>
        <td>
                <button value="bbu" class="greenbutton" onclick="submitform2(r,\'bbu\')" >Bollinger Oversold (Bullish)</button>
        </td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>    <button value="bbe" class="redbutton" onclick="submitform2(r,\'bbe\')" >Bollinger Overbought (Bearish)</button>
        </td>
        </tr>
        <tr><td height="3" style="line-height:0px; font-size:0px;">&nbsp;</td></tr>
  <tr>
        <td>
                <button value="rs" class="greenbutton" onclick="submitform2(r,\'rs\')" >RSI Oversold (Bullish)</button>
        </td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>    <button value="rb" class="redbutton" onclick="submitform2(r,\'rb\')" >RSI Overbought (Bearish)</button>
        </td>
        </tr>
        <tr><td height="3" style="line-height:0px; font-size:0px;">&nbsp;</td></tr>
   <tr>
        <td>
                <button value="ss" class="greenbutton" onclick="submitform2(r,\'ss\')" >Stochastic Oversold (Bullish)</button>

        </td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>    <button value="sb" class="redbutton" onclick="submitform2(r,\'sb\')" >Stochastic Overbought (Bearish)</button>
        </td>
        </tr>
        <tr><td height="3" style="line-height:0px; font-size:0px;">&nbsp;</td></tr>
  <tr>
        <td>
                <button value="ss" class="greenbutton" onclick="submitform2(r,\'ssr\')" >Stochastic RSI Oversold (Bullish)</button>

        </td>
        <td><img src="http://tickerlick.com/images/spacer.gif" width = "5" height=5></td>
        <td>    <button value="sb" class="redbutton" onclick="submitform2(r,\'sbr\')" >Stochastic RSI Overbought (Bearish)</button>
        </td>
        </tr>
        <tr><td height="3" style="line-height:0px; font-size:0px;">&nbsp;</td></tr>
        <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=5></td></tr>
  </table></form>';
print $documentBuffer111;
#if it is a request to print reports, please ignore ticker value ($q->param("q")
if (defined($q->param("s")))
{
 $rep_type = $q->param("s"); 
 $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
 if ($rep_type eq 'os')
{
    $title = "MACD (5,35,5) Oversold (Bullish)";
    $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'OS' and b.ticker_id = a.ticker_id order by sector";
     }
elsif ($rep_type eq 'osx')
{
    $title = "S&P 500 - MACD (5,35,5) Oversold (Bullish)";
    $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'OS' and b.ticker_id = a.ticker_id and a.tflag = 'Y' order by sector";
     }
elsif ($rep_type eq 'ob')
{
     $title = "MACD (5,35,5) Overbought (Bearish)";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'OB' and b.ticker_id = a.ticker_id order by sector";
     }
elsif ($rep_type eq 'rs')
{
     $title = "RSI Oversold (Bullish)";
     $query = "select ticker, comp_name,sector, industry from tickermaster a, report b where report_flag in ('RS') and a.ticker_id = b.ticker_id order by sector";
}
elsif ($rep_type eq 'rsx')
{
     $title = "S&P 500 - RSI Oversold (Bullish)";
     $query = "select ticker, comp_name,sector, industry from tickermaster a, report b where report_flag in ('RS') and a.ticker_id = b.ticker_id  and a.tflag = 'Y' order by sector";
}
elsif ($rep_type eq 'rb')
{
     $title = "RSI Overbought (Bearish)";
     $query = "select ticker, comp_name,sector, industry from tickermaster a, report b where report_flag in ('RB') and a.ticker_id = b.ticker_id order by sector";
}
elsif ($rep_type eq 'ss')
{
     $title = "Stochastic Oversold (Bullish)";
     $query = "select ticker, comp_name,sector, industry from tickermaster a, report b where report_flag in ('SS') and a.ticker_id = b.ticker_id order by sector";
}
elsif ($rep_type eq 'ssx')
{
     $title = "S&P 500 - Stochastic Oversold (Bullish)";
     $query = "select ticker, comp_name,sector, industry from tickermaster a, report b where report_flag in ('SS') and a.ticker_id = b.ticker_id  and a.tflag = 'Y' order by sector";
}
elsif ($rep_type eq 'sb')
{
     $title = "Stochastic Overbought (Bearish)";
     $query = "select ticker, comp_name,sector, industry from tickermaster a, report b where report_flag in ('SB') and a.ticker_id = b.ticker_id order by sector";
}
elsif ($rep_type eq 'mbu')
{
     $title = "MACD Bullish Crossover";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'MBL' and b.ticker_id = a.ticker_id order by sector";
}
elsif ($rep_type eq 'mbux')
{
     $title = "S&P 500 - MACD Bullish Crossover";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'MBL' and b.ticker_id = a.ticker_id and a.tflag = 'Y' order by sector";
}
elsif ($rep_type eq 'mbe')
{
     $title = "MACD Bearish Crossover";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'MBX' and b.ticker_id = a.ticker_id order by  sector";
}
elsif ($rep_type eq 'vbe')
{
     $title = "Vey Bearish";
     $query = "SELECT a.ticker,a.comp_name,sector,industry from tickermaster a, (select ticker_id,count(*) from report where report_flag in ('SB','RB','OB','MBX') group by ticker_id having count(*) > 2) ab where a.ticker_id = ab.ticker_id";
}
elsif ($rep_type eq 'vbu')
{
     $title = "Vey Bullish";
     $query = "SELECT a.ticker,a.comp_name,sector,industry from tickermaster a, (select ticker_id,count(*) from report where report_flag in ('SS','RS','OS','MBL') group by ticker_id having count(*) > 2) ab where a.ticker_id = ab.ticker_id";
}
elsif ($rep_type eq 'bbu')
{
     $title = "Bollinger Bullish";
      $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'BBU' and b.ticker_id = a.ticker_id order by sector desc";
}
elsif ($rep_type eq 'bbux')
{
     $title = "S&P 500 - Bollinger Bullish";
      $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'BBU' and b.ticker_id = a.ticker_id  and a.tflag = 'Y' order by sector desc";
}
elsif ($rep_type eq 'bbe')
{
     $title = "Bollinger Bearish";
     $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'BBE' and b.ticker_id = a.ticker_id order by  sector desc";
}
elsif ($rep_type eq 'xos')
{
     $title = "Extremely Oversold";
     $query = "SELECT distinct a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b, (select ticker_id,count(*) from report c where c.report_flag in ('BBU','MBL','OS','RS','SS') group by c.ticker_id having count(*) > 2) c where b.ticker_id = a.ticker_id and b.ticker_id = c.ticker_id order by sector";
}
elsif ($rep_type eq 'xob')
{
     $title = "Extremely Overbought";
     $query = "SELECT distinct a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b, (select ticker_id,count(*) from report c where c.report_flag in ('BBE','MBX','OB','RB','SB') group by c.ticker_id having count(*) > 2) c where b.ticker_id = a.ticker_id and b.ticker_id = c.ticker_id order by sector";
}
elsif ($rep_type eq 'sbr')
{
     $title = "RSI Stochastic Overbought (Bearish)";
     $query = "select ticker, comp_name,sector, industry from tickermaster a, report b where report_flag in ('SBR') and a.ticker_id = b.ticker_id order by sector";
}
elsif ($rep_type eq 'ssr')
{
     $title = "RSI Stochastic Oversold Bullish";
      $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'SSR' and b.ticker_id = a.ticker_id order by sector desc";
}
elsif ($rep_type eq 'ssrx')
{
     $title = "S&P 500 - RSI Stochastic Bullish";
      $query = "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'SSR' and b.ticker_id = a.ticker_id  and a.tflag = 'Y' order by sector desc";
}
 print '<table border="1" cellpadding="1" cellspacing="1" width="70%" align="center" style="border-collapse: collapse;">';
 if ($rep_type ne 'ef' && $rep_type ne 'nf')
   {
   print '<div id="bottom"></div>';
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
     print "<a href=http://www.tickerlick.com/cgi-bin/gettickermain2json.cgi?q=".$row[0].">".$row[0]."</a></td><td>" . $row[1] ."</td><td>". $row[2] ."</td><td>". $row[3];
     print "</td></tr>";
   }
   elsif ($rep_type eq 'ef')
   {
      print "<tr><td>";
      print "<a href=http://www.tickerlick.com/cgi-bin/gettickermain2json.cgi?q=".$row[0].">".$row[0]."</a></td><td>" . $row[1] ."</td><td>". $row[2] ."</td><td>". $row[3]."</td><td>". $row[4]."</td><td>". $row[5]."</td><td>". $row[6]."</td><td>". $row[7]."</td><td>". $row[8]."</td><td>". $row[9]."</td><td>". $row[10]."</td><td>". $row[11]."</td><td>". $row[12]."</td><td>". $row[13]."</td><td>". $row[29]."</td><td>".$row[47]."</td><td>".$row[54]; 
     print "</td></tr>";
   }
   else
   {
     print "<tr><td>";
     print "<a href=http://www.tickerlick.com/cgi-bin/gettickermain2json.cgi?q=".$row[0].">".$row[0]."</a></td><td>" . $row[1] ."</td><td>". $row[2] ."</td><td>". $row[3]."</td><td>". $row[4]."</td><td>". $row[5]."</td><td>". $row[6]."</td><td>". $row[7]."</td><td>". $row[8]."</td><td>". $row[9]."</td><td>". $row[10]."</td><td>". $row[11]."</td><td>". $row[12]."</td><td>". $row[13]."</td><td>". $row[30]."</td><td>". $row[36];
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

my %tickerhash = getResultsjson($querytext);
#my $resulthtml = '<iframe align="middle" height="400" frameborder="0">';
my $tophtml  .= '<table border="1" cellpadding="1" cellspacing="1" width="70%" align="center" style="border-collapse: collapse;">';
#print "ddddddd:$tickerhash{invalidticker}\n";
if ($tickerhash{invalidticker})
{
   $tophtml .= "<tr><td><table align=\"center\" style=\"border-collapse: collapse;\"><tr><td>Ticker <strong>$querytext</strong> is invalid or insufficient trading or company data. Please check the Ticker.</td></tr></table></td></tr></table>";
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
  $tophtml .= "<tr><td><table style=\"border-collapse: collapse;\"><tr><td>Ticker&nbsp;:&nbsp;$tickerhash{Ticker}</td><td>Name&nbsp;:&nbsp;$tickerhash{name}</td></tr></table></td></tr>";

$result2html .= "<tr><td><table style=\"border-collapse: collapse;\"><tr><td>Last Trade&nbsp;:&nbsp;$tickerhash{LastTrade}</td><td>Prev Close&nbsp;:&nbsp;$tickerhash{PrevClose}</td><td>Volume&nbsp;:&nbsp;$tickerhash{vol}</td></tr><tr><td>Nav&nbsp;:&nbsp;$tickerhash{Nav}</td><td>52 Week Range&nbsp;:&nbsp;$tickerhash{wkRange}</td><td>Yield&nbsp;:&nbsp;$tickerhash{DivYield}</td></tr></table></td></tr>";
}
else
{
 #$resulthtml .= $charthtml;
 $tophtml .= "<tr><td><table style=\"border-collapse: collapse;\"><tr><td>Ticker&nbsp;:&nbsp$tickerhash{Ticker}</td><td>Name&nbsp;:&nbsp$tickerhash{name}</td><td>Sector&nbsp;:&nbsp$tickerhash{sector}</td><td>Industry&nbsp;:&nbsp$tickerhash{industry}</td></tr></table></td></tr>";
$result2html = "<tr><td><table style=\"border-collapse: collapse;\"><tr><td>Last Trade&nbsp;:&nbsp$tickerhash{LastTrade}</td><td>Prev Close&nbsp;:&nbsp$tickerhash{PrevClose}</td><td>Volume&nbsp;:&nbsp$tickerhash{vol}</td><td>1 Year Target Est&nbsp;:&nbsp$tickerhash{yTargetEst}</td></tr><tr><td>52 Week Range&nbsp;:&nbsp$tickerhash{wkRange}</td></tr></table></td></tr>";
}
#technical analysis data
$charthtml = $tophtml.'<tr><td><table style=\"border-collapse: collapse;\"><tr><td rowspan="2"><p align="justify"><b><font color="#000000" size="+2">'.$tickerhash{LastTrade}.'</font>';

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
$resulthtml .= "<tr><td><table style=\"border-collapse: collapse;\"><tr><td>PE&nbsp;:&nbsp$tickerhash{PE}</td><td>Forward PE&nbsp;:&nbsp$tickerhash{ForwardPE}</td><td>EPS&nbsp;:&nbsp$tickerhash{EPS}</td></tr><tr><td>Market Cap&nbsp;:&nbsp$tickerhash{MarketCap}</td><td>Sector&nbsp;:&nbsp$tickerhash{sector}</td><td>Industry&nbsp;:&nbsp$tickerhash{industry}</td></tr><tr><td>10 Day Moving Average&nbsp;:&nbsp$tickerhash{dma10}</td><td>50 Day Moving Average&nbsp;:&nbsp$tickerhash{dma50}</td><td>200 Day Moving Average&nbsp;:&nbsp$tickerhash{dma200}</td></tr>
</table>

</td></tr>

</table>";
}
#print $resulthtml;
#print historical price and DMA

if ($tickerhash{Ticker})
{
 $tickerhash{Ticker}  =~ s/\'//g;
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
      if ($repflag =~ /OS|SS|RS|BBU/)
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
if ($signalhash{macd535})
   {  
     #print "$signalhash{macd535}\n"; 
     my ($signaldate,$signal) = split (/\t/,$signalhash{macd535});
   if ($signal eq "Buy")
   {

     $macdhtml .= '<br>Current MACD (5,35,5) trend is <font color="#05840C" size="+2">Bullish</font>. Last crossover was on <strong>'.$signaldate.'</strong>.';
   }
   else
   {
     $macdhtml .= '<br>Current MACD (5,35,5) trend is <font color="#FF0000" size="+2">Bearish</font>. Last crossover was on <strong>'.$signaldate.'</strong>.';
   }
}

#my $ratinghtml = &getratinghistory($ticker_id);   
   $pricehistoryhtml = &getpricehistory($ticker_id,100); 
  $charthtml .= $rep_flag_html.$macdhtml."</td></tr></table></td></tr>";
  $resulthtml = $charthtml.$resulthtml;
  if ($tickerhash{tflag} eq 'Y')
 {
   my $dow = Today();
   my $maxtick = 150;
   if ($ticker_id == 10909){$maxtick = 390;}
   if (&marketlive())
   {
   print "<tr><td><table align=\"center\" style=\"border-collapse: collapse;\"><tr><td><IMG SRC=\"/cgi-bin/graphdmadaily.cgi?tickid=$ticker_id&dow=$dow&maxtick=$maxtick=$dow&maxtick =\"></td><td><IMG SRC=\"/cgi-bin/graphmacddaily.cgi?tickid=$ticker_id&dow=$dow&maxtick=$maxtick\"></td></tr></table></td></tr>";
   print "<tr><td><table align=\"center\" style=\"border-collapse: collapse;\"><tr><td><IMG SRC=\"/cgi-bin/graphrsidaily.cgi?tickid=$ticker_id&dow=$dow&maxtick=$maxtick\"></td><td><IMG SRC=\"/cgi-bin/graphbollidaily.cgi?tickid=$ticker_id&dow=$dow&maxtick=$maxtick\"></td></tr></table></td></tr>";
}
}
  print "<tr><td><table align=\"center\" style=\"border-collapse: collapse;\"><tr><td><IMG SRC=\"/cgi-bin/graphMACD4.cgi?tickid=$ticker_id\"></td><td><IMG SRC=\"/cgi-bin/graphRSI.cgi?tickid=$ticker_id\"></td></tr></table></td></tr>";
  print "<tr><td><table align=\"center\" style=\"border-collapse: collapse;\"><tr><td><IMG SRC=\"/cgi-bin/graphStoch.cgi?tickid=$ticker_id\"></td><td><IMG SRC=\"/cgi-bin/graphBOLLIs.cgi?tickid=$ticker_id\"></td></tr></table></td></tr>";
   #print "<tr><td><table align=\"center\" style=\"border-collapse: collapse;\"><tr><td><IMG SRC=\"/cgi-bin/graphBOLLI.cgi?tickid=$ticker_id\"></td></tr></table></td></tr>";
  print "$resulthtml\n";
  #print "$ratinghtml\n";
   print '<div ng-app="myApp" ng-controller="customersCtrl">
<table border="1" cellpadding="1" cellspacing="1" width="70%" align="center" style="border-collapse: collapse;">
<tr bgcolor="#00FFFF"><th colspan=12>Analyst Coverage</th></tr>
<tr bgcolor="#00FFFF"><td>Brokerage Name</td><td>Date</td><td>Action</td><td>Rating From</td><td>Rating To</td><td>Price From</td><td>Price To</td></tr>
  <tr ng-repeat="x in names">
    <td>{{ x.brokeragename }}</td>
    <td>{{ x.ratingdate }}</td>
    <td>{{ x.updown }}</td>
    <td>{{ x.ratingfrom }}</td>
    <td>{{ x.ratingto }}</td>
    <td>{{ x.pricefrom }}</td>
    <td>{{ x.priceto }}</td>
  </tr>
</table>

</div>

<script>
var app = angular.module("myApp", []);
app.controller("customersCtrl", function($scope, $http) {
   $http.get("http://www.tickerlick.com/angular/rating.php?q='.$ticker_id.'")
   .then(function (response) {$scope.names = response.data.records;});
});
</script>'; 
  print "$pricehistoryhtml\n";
}
}
#print "<\iframe>\n";

#if ($tickerhash{class} eq 'ETF')
#{
# $framehtml = '<iframe align="middle" height="250" frameborder="0"></iframe>';
# print "$framehtml\n";
#}
my $documentBuffer2 = '<table align="center" style="border-collapse: collapse;">
  <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=30></td></tr>
  <tr>
        <td align="center"><font size=-2>&copy;2012 Tickerlick - All rights reserved.</font><p></p>
        </td>

  </tr>
   <tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=10></td></tr>
   </table>
</body>
</html>';

print $documentBuffer2;
1;
