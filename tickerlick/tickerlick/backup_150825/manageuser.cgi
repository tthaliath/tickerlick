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
require "gettickerdet.pl";
require "updatetickerpricedata_new.pl";
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
<meta name="keywords" lang="en-US" content="MACD, Stochastic, Bollinger, RSI, Oversold, Overbought, Stock Research, Investment Tools"/>
<script language="javascript" type="text/javascript">
function setFocus(){document.f.q.focus();}
function submitform(obj ) {
    var l = obj
           var s = l.q.value.split(" ");
           l.q.value = s[0];
           document.f.action = "/cgi-bin/gettickerdataone.cgi";
           document.f.submit();
           return true;

}
</script>
<script>
function submitform2(obj,reptype) {
           var r = obj
           r.s.value = reptype;
           document.r.action = "/cgi-bin/gettickerdataone.cgi";
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
       <form  name=f METHOD=GET action="/cgi-bin/gettickerdataone.cgi">
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
<form  name=r METHOD=GET action="/cgi-bin/gettickerdataone.cgi">
<input type="hidden" name="s">
  </form>'; 
print $documentBuffer1;
#if it is a request to print reports, please ignore ticker value ($q->param("q")
if (defined($q->param("s")))
{
 $rep_type = $q->param("s"); 
 $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
     print "<tr><td>";
     print "<a href=http://www.tickerlick.com/cgi-bin/gettickerdataone.cgi?q=".$row[0].">".$row[0]."</a></td><td>" . $row[1] ."</td><td>". $row[2] ."</td><td>". $row[3];
     print "</td></tr>";
     print "<a href=http://www.tickerlick.com/cgi-bin/gettickerdataone.cgi?q=".$row[0].">".$row[0]."</a></td><td>" . $row[1] ."</td><td>". $row[2] ."</td><td>". $row[3]."</td><td>". $row[4]."</td><td>". $row[5]."</td><td>". $row[6]."</td><td>". $row[7]."</td><td>". $row[8]."</td><td>". $row[9]."</td><td>". $row[10]."</td><td>". $row[11]."</td><td>". $row[12]."</td><td>". $row[13]."</td><td>". $row[30]."</td><td>". $row[36];
    print "</td></tr>";
 
 print "</table>";
 $sth->finish();
}
$resulthtml .=$result2html; 
$resulthtml = "</table>

</td></tr>

</table>";
  my $documentBuffer2 = '<tr><td><img src="http://tickerlick.com/images/spacer.gif" width = "100%" height=20></td></tr>
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
