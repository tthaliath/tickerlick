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
use CGI;
use TickerDB;
use GetTickerData;
use UpdateTickerPriceData;
use DBI;
my ($q) = new CGI;
my (@locarr,$sql,@row,$location,$querytext,$offset,$catid,$pagetype,$row_count,$l,$keypat,@lindexarr,$res_count,$resulthtml,$result2html,$macdhtml,$charthtml,$framehtml);
my ($size,$nolinks,$sortby,$keycnt,$query_option);
my $dbh = DBI->connect('dbi:mysql:tickmaster','root','Neha*2005') or die "Connection Error: $DBI::errstr\n";
#use ISTR::Search;
#my ($SEARCH) = ISTR::Search->new();
require "/home/tickerlick/cgi-bin/getsecnoticelinks.pl";
print "Content-type:text/html\n\n";

#foreach (@locarr){print "location:$_<br>";}
$querytext = $q->param("q");
my ($documentBuffer1) = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script language="javascript" type="text/javascript">
function setFocus(){document.f.q.focus();}
function submitForm2(obj ) {
    var l = obj
	var len = document.f.l.options.length
	if (l.value == "Search" )
	{
	   document.f.lindex.value = len
	   document.f.action = "/cgi-bin/getsecfilings.cgi";
	   document.f.submit();
	   return true;
	 }

}
function submitform(obj ) {
    var l = obj
           var s = l.q.value.split(" ");
           l.q.value = s[0];
           document.f.action = "/cgi-bin/getsecfilings.cgi";
           document.f.submit();
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
       <form  name=f METHOD=GET action="/cgi-bin/getsecfilings.cgi">
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
print $documentBuffer1;
 if ($querytext)
 {
   &getsecfiles($querytext);
   $querytext =~ s/\-//g;
   $sql ="select a.ticker,a.file_url, a.file_type, a.file_date, b.comp_name from sec_filing a, tickermaster b where a.ticker = '$querytext' and a.ticker_id = b.ticker_id order by a.ticker, a.file_date desc";
 my $resulthtml  = '<table border="1" cellpadding="1" cellspacing="1" width="100%" align="center" style="border-collapse: collapse;">';
 $resulthtml  .= '<tr bgcolor="#00FFFF"><th colspan=12>Latest SEC Filings</th></tr>';
$resulthtml .= '<tr bgcolor="#00FFFF"><td>Company</td><td>Ticker</td><td>Type</td><td>File Date</td></tr>';
 my $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";
 while (@row = $sth->fetchrow_array)
 {
      $resulthtml .= "<tr><td>" . $row[4] ."</td><td>" . $row[0] ."</td><td><a href=".$row[1].">".$row[2]."</a></td><td>" . $row[3] ."</td></tr>";
 }
 $sth->finish;
 $resulthtml .= "</table>";
 print "$resulthtml\n";
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
