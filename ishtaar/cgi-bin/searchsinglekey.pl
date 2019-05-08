#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: searchsinglekey.pl
#Date started : 06/24/03
#Last Modified : 06/24/03
#Purpose : Display the search result when there is only only keywords from category file
$| = 1;
use strict;
my (%in,$key,$key1,$key2,$val,$envstr,@envlist,$arrln,$i);
require "searchresultbykeynew1.pl";
print "Content-type:text/html\n\n";
# Check the request method and get the variables
if (&ismethod() eq 'GET')
 {
    $envstr = $ENV{'QUERY_STRING'};
 }
 elsif(&ismethod() eq 'POST')
 {
    read(STDIN,$envstr,$ENV{'CONTENT_LENGTH'});
 }

# Parse the query string for variable values  
@envlist = split(/&/,$envstr);
$arrln = $#envlist;
foreach $i(0..$arrln)
{

$envlist[$i] =~s/\+/ /g;
($key,$val) = split(/=/,$envlist[$i],2);
$key=~s/%(..)/pack("c",hex($1))/ge;
$val=~s/%(..)/pack("c",hex($1))/ge;
if ($in{$key}){$in{$key} .= ",$val";}
else{$in{$key} = $val;}
                   
} 
my ($databufheader) = '<html><head><meta http-equiv="content-type" content="text/html; charset=UTF-8"><title>Ishtaar</title><style><!--
body,td,a,p,.h{font-family:arial,sans-serif;}
.h{font-size: 20px;}
.q{text-decoration:none; color:#0000cc;}
//-->
</style>
<script>
<!--
function sf(){document.f.q.focus();}
function c(p,l,e){var f=document.f;if (f.action && document.getElementById) {var hf=document.getElementById("hf");if (hf) {var t = "<input type=hidden name=tab value="+l+">";hf.innerHTML=t;}f.action = "http://"+p;e.cancelBubble=true;f.submit();return false;}return true;}
// -->
</script>
</head><body bgcolor=#ffffff text=#000000 link=#0000cc vlink=#551a8b alink=#ff0000 onLoad=sf()>
<img src="/image/ishtaarlogo.png" width=100 height=45 alt="ISHTAAR"> 
<table><tr>
  <td><font color="#0000FF">I</font>nternational <font color="#CC0000">S</font>oftware, <font color="#0000FF">H</font>uman
    Capital, <font color="#CC0000">T</font>echnology <font color="#0000FF">A</font>nd <font color="#CC0000">A</font>dvanced <font color="#0000FF">R</font>esources</td>
  </tr></table>
  
  <form action="/cgi-bin/searchsinglekey.pl" name=f>
    <table cellspacing=0 cellpadding=0>
      <!--DWLayoutTable-->
      <tr><td>Type Keyword</td><td>&nbsp;&nbsp;</td>
        <td align=center> 
          <input maxLength=256 size=45 name=q value=""></td><td>&nbsp;&nbsp;</td><td>Location:</td>
		  <td><select name=l>
		  <option value=all>---Select All---</option>
		  <option value=bangalore>Bangalore</option>
		  <option value=chennai>Chennai</option>
		  <option value=trivandrum>Trivandrum</option>
                  <option value=hyderabad>Hyderabad</option>
                  <option value=pune>Pune</option>
		  </select></td>
         <td>&nbsp;&nbsp;</td>
<td><input type=submit value="Search" name=s></td><br>
  </td>
<td>&nbsp;</td>
</tr></table>
</form>
  <table width="100%" border="0" align="left">
  <tr>
    <td><font size="2">Searched database for keywords list of keywords</font></td>
  </tr>
  <tr>
    <td><font size="2">No Of results 50: 1-25 Displayed</font></td>
  </tr>
</table>
<br>
<p><br><br>
  <table width="100%" border="0" cellpadding="0" cellspacing="0" align="left"><!--DWLayoutTable-->';
 
print $databufheader;
$key = $in{q};
#my @keyarr = split(/\,/,$key);
#($key1,$key2) = &prepareKeywords($key);
#my (@loclist) = split(/,/,$in{l});
my ($location) = $in{l};
&getresults($key,33);

my ($databuffooter) = '</table><br>
<p><br><br>
<input type=submit value="Advanced Search" name=as>
<input type=submit value="Browse Categories" name=bc>
<input type=submit value="Register Your Firm" name=rf>
<br>
<p><br>
<font size=-1><a href="/aboutus.htm">About&nbsp;Us</a> - <a href="/contactus.htm">Contact
Us</a> <span id=hp style="behavior:url(#default#homepage)"></span>
</font>
<p><font size=-2>&copy;2003 Ishtaar - All Rights Reserved</font></p>
</center></body></html>';
print $databuffooter;

# Function to return the request type.
sub ismethod{
 return $ENV{'REQUEST_METHOD'};
}
