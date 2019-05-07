#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: snapshot.pl
#Date started : 11/09/03
#Last Modified : 11/09/03
#Purpose : Display the text of  a link
use strict;
use CGI;
use DB_File;
my ($q) = new CGI;
print "Content-type:text/html\n\n";
$| = 1;
#get all the form variable values
#my (@locarr) = $q->param("l");
#foreach (@locarr){print "location:$_<br>";}
my ($linkid) = $q->param("linkid");
my ($filename) = $q->param("fn")."\.txt";
my ($terms) = $q->param("terms");
my ($cat) = $q->param("cat") || 1;
my ($url,$linktext,%cat_hash,$keypat,$val);
my ($patexists) = 0;
my ($linkhead,$linkbody);
if ($cat){
my $catfilename = 'category_desc_lookup_dbfile.txt';
tie (%cat_hash, 'DB_File', $catfilename, O_RDWR, 0444, $DB_BTREE) || die $!;
foreach $val(split(/\|/,$terms)){
$keypat .= $cat_hash{$val}.'|';
}
untie %cat_hash;
}
else{$keypat = $terms;}
undef $/;
open (F,"data/$filename");
my ($text) = <F>;
$/ = "\n";
close(F);
while ($text =~ /\b$linkid\b\t(.*?)\n(.*?)\n\n/mg)
{
    ($url) = $1;
    ($linktext) = $2;
    #print "<br>$keypat\n";
    $keypat =~ s/(.*)\|$/$1/g;
    if ($linktext =~ /$keypat/i){
    $patexists = 1;
    #print "<br>$keypat\n";
    #if ($linktext =~ /(.*?)(<body.*)/i){
   # $linkhead = $1;
   # $linkbody = $2;
   # }
    if ($linktext =~ /(.*?)(<body.*)/){
    my ($a) = $1;
    my ($b) = $2;
    #$linktext =~ s/([\s|\(]$keypat[\s|\)])/<font color=#FF0000>\1<\/font>/gi;
     #$b =~ s/((!href.*?$keypat[\/|\.])[\s|\(]$keypat[\s|\)])/<font color=#FF0000>\1<\/font>/sgi;
     $b =~ s/\s+/ /g;
     $b =~ s/([\s|\(]$keypat[\s|\)])/<font color=#FF0000>\1<\/font>/sgi;
     $b =~ s/($keypat)/<font color=#FF0000>\1<\/font>/sgi;
     $b =~ s/(href.*?)<font color\=\#FF0000>($keypat)<\/font>/\1\2/sgi;
     $linktext = $a.$b;
    }
   } 
     
    #print "<br>$linktext\n";
    #$linktext =~ s/\/\.\.\//\//g;
    #$linktext =~ s/\.\.\//\//g;
    $keypat =~ s/\|/ /g;
    last;
}
my ($documentBuffer)= '<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<BASE HREF='.$url.'><script language="javascript" type="text/javascript">

function submitForm( ) {
	if (document.f.name = "s")
	{
	   document.f.action = "/cgi-bin/search.pl";
	   document.f.submit();
	   return true;
	 }
}
</script>
<style type="text/css">
<!--
/* other font types */
	.titletext {font-family: arial, helvetica, sans-serif; font-size: 10pt; color: #FF6600}
	.companytext {font-family: arial, helvetica, sans-serif; font-size: 15pt;}
	.bluetext {font-family: arial, helvetica, sans-serif; font-size: 11pt; color: #3366CC }
	.bluetextbold {font-family: arial, helvetica, sans-serif; font-size: 12pt; color: #3366CC; font-weight: bold}
        .bluetextsmall {font-family: arial, helvetica, sans-serif; font-size: 11px; color: #3366CC}
	.linktext {font-family: arial, helvetica, sans-serif; font-size: 9pt; color: #FF0000}
        .linktextlarge {font-family: arial, helvetica, sans-serif; font-size: 11pt; color: #FF0000}
	.blueheader {font-family: arial, helvetica, sans-serif; font-size: 13pt; color: #039; font-weight: bold}
	.lightblueheader {font-family: arial, helvetica, sans-serif; font-size: 14pt; color: B6C6D9;}
	.whiteheader {font-family: arial, helvetica, sans-serif; font-size: 13pt; color: #FFFFFF; font-weight: bold}
	.bwheader {font-family: arial, helvetica, sans-serif; font-size: 13pt; color: T_COLOR_FONT; font-weight: bold}
    	.highlight {background: #6D8CB3; color: #FFFFFF;}
    	.errortext {font-family: arial, helvetica, sans-serif; font-size: 10pt; color: #FF0000; font-weight: bold; text-align: center}

	-->
</style>
  <table align="center">
  <tr><td><img src="http://69.59.182.204/images/spacer.gif" width = "100%" height=20></td></tr>
  <tr>
        <td align="center"><img src="http://69.59.182.204/images/ishtaarlogo.png" width=80 height=50 alt="ISHTAAR"></td>
	</tr>
		<tr>
        <td align="center" height="25" class="companytext" ><font color="#0000FF">I</font>nternational 
          <font color="#CC0000">S</font>oftware, <font color="#0000FF">H</font>uman 
          Capital, <font color="#CC0000">T</font>echnology <font color="#0000FF">A</font>nd 
          <font color="#CC0000">A</font>dvanced <font color="#0000FF">R</font>esources 
        </td>
  </tr>
   <tr><td><img src="http://69.59.182.204/images/spacer.gif" width = "100%" height=10></td></tr>';

 
 
print "$documentBuffer";

    print "<tr><td><span class=bluetext>
          Below is the text of the page </span><a href=$url><font class=linktextlarge>$url</font></a><span class=bluetext>. Its a snapshot of the page taken as our 
          search engine crawled the web. Since then, the page may have changed or deleted. Check the </span>
          <a href=$url><font class=linktextlarge>Current Page</font></a>.<br><br>";
if ($patexists){
print "<span class=bluetext>These search terms have been highlighted: <b>".uc($keypat)."</b></span>";
}
print "</td></tr></table><hr>$linktext\n";
