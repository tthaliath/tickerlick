#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: search.pl
#Date started : 06/24/03
#Last Modified : 11/07/03
#Purpose : Display the search result for the terms entered by user
$| = 1;
use strict;
use CGI;
my ($q) = new CGI;
my (@locarr,$location,$querytext,$offset,$catid,$pagetype,$row_count,$l,$keypat,@lindexarr,$res_count);
my ($size,$nolinks,$sortby,$keycnt,$query_option);

require "searchfunc.pl";
print "Content-type:text/html\n\n";
#get all the form variable values
$offset = $q->param("fr");
$row_count= $q->param("rc");
$pagetype = $q->param("pt");
$size = $q->param("cs");
$sortby = $q->param("so");
$nolinks = $q->param("nl");
$keycnt = $q->param("kc");
$query_option = $q->param("q_o");
#print "<br>$querytext";
#$querytext =~ s/\s/\\/g;
if ($pagetype eq 'MAIN' ) #The request is from main search
{
$querytext = $q->param("q");
@locarr = $q->param("l");
@lindexarr = split(/,/,$q->param("lindex"));
$l = join(/,/,@lindexarr);
$location = join(',',@locarr);
}

else{
if ($pagetype eq 'RESULT' ) #The request is from results page
{
 $querytext = $q->param("q");
  $location = $q->param("lid");
  $catid = $q->param("catid");
  $keypat = $q->param("catstr");
  $res_count = $q->param("rt");
}
else
{
  @locarr = $q->param("l2");
  @lindexarr = split(/,/,$q->param("lindex"));
  $l = join(/,/,@lindexarr);
$location = join(',',@locarr);
}
}
my ($documentBuffer) = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Ishtaar: International Software, Human Capital, Technology And Advanced Resources</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">


<script language="javascript" src="/scripts/location.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript">
function setFocus(){document.f.q.focus();}
function submitForm(obj ) {
        var o = obj
        if (o.name == "s2"){
        if (o.value == "Search")
        {
           document.f.action = "/cgi-bin/search.pl";
           document.f.submit();
           return true;
         }
        }
        if (o.name == "s"){
        if (o.value == "Search")
        {
           document.f.action = "/cgi-bin/searchkey.pl";
           document.f.submit();
           return true;
         }
        }
}

</script>
<link rel="stylesheet" href="/common/ishtaar.css" type="text/css">

</head>
<body leftmargin="0" topmargin="0" marginheight="0" marginwidth="0" link=#0000cc vlink=#551a8b alink=#ff0000 onLoad="locationDropPageLoad(document.f.c,document.f.l);">
 <table align="left" width="90%" border="0"  cellpadding="0" cellspacing="0"><tr><td>
 <form  name=f METHOD=GET>
	  <input type="hidden" name="fr" value=0>
          <input type="hidden" name="rc" value=10>
          <input type="hidden" value="" name="lindex">
          <input type="hidden" value="MAIN" name="pt">
          <input type="hidden" value="r" name="so">
          <input type="hidden" value=5 name="nl">
		  <input type="hidden" value=2 name="q_0">
		  <table align="left" width="85%" border="0"  cellpadding="0" cellspacing="0">
		  <tr>
                  <td><img src="/images/spacer.gif"  height=10></td>
                </tr>
		  <tr>
      <td height="19" colspan="6" align="right"><a href="http://69.59.182.204/index29.html">Home</a>&nbsp;&nbsp;<a href="http://69.59.182.204/checkyourfirm.html">Register Your firm</a></td></tr>

		  <tr><td><img src="/images/spacer.gif" height=11></td></tr>
          <tr>
		    <td><img src="/images/spacer.gif" width = "25" height=1></td> 
            <td class="bluetext">Enter Keywords (Category, Skill)</td>
            <td class="bluetext">Country</td>
            <td class="bluetext">City/Province/Region:</td>
          </tr>
          <tr valign="top">
		    
      <td align="center"><a href="http://69.59.182.204/index29.html"><img border=0 src="/images/ishtaarlogo.png" width=80 height=21 alt="ISHTAAR" ></a>
	  </td> 
            
      <td ><input type="text" name="q" size="50" maxlength="255" value=""></td>
            <td> <select name="c"  onChange="locationDrop(this,document.f.l)">
                <option value="us" selected> United States </option>
                <option value="ca"> Canada </option>
                <option value="in"> India </option>
                <option value="cn"> China </option>
                <option value="af"> Afghanistan </option>
                <option value="al"> Albania </option>
                <option value="dz"> Algeria </option>
                <option value="as"> American Samoa </option>
                <option value="ad"> Andorra </option>
                <option value="ao"> Angola </option>
                <option value="ai"> Anguilla </option>
                <option value="aq"> Antarctica </option>
                <option value="ag"> Antigua and Barbuda </option>
                <option value="ar"> Argentina </option>
                <option value="am"> Armenia </option>
                <option value="aw"> Aruba </option>
                <option value="au"> Australia </option>
                <option value="at"> Austria </option>
                <option value="az"> Azerbaijan </option>
                <option value="bs"> Bahamas </option>
                <option value="bh"> Bahrain </option>
                <option value="bd"> Bangladesh </option>
                <option value="bb"> Barbados </option>
                <option value="by"> Belarus </option>
                <option value="be"> Belgium </option>
                <option value="bz"> Belize </option>
                <option value="bj"> Benin </option>
                <option value="bm"> Bermuda </option>
                <option value="bt"> Bhutan </option>
                <option value="bo"> Bolivia </option>
                <option value="ba"> Bosnia and Herzegovina </option>
                <option value="bw"> Botswana </option>
                <option value="bv"> Bouvet Island </option>
                <option value="br"> Brazil </option>
                <option value="io"> British Indian Ocean Territory </option>
                <option value="bn"> Brunei Darussalam </option>
                <option value="bg"> Bulgaria </option>
                <option value="bf"> Burkina Faso </option>
                <option value="bi"> Burundi </option>
                <option value="kh"> Cambodia </option>
                <option value="cm"> Cameroon </option>
                <option value="cv"> Cape Verde </option>
                <option value="ky"> Cayman Islands </option>
                <option value="cf"> Central African Republic </option>
                <option value="td"> Chad </option>
                <option value="cl"> Chile </option>
                <option value="cx"> Christmas Island </option>
                <option value="cc"> Cocos (Keeling) Islands </option>
                <option value="co"> Colombia </option>
                <option value="km"> Comoros </option>
                <option value="cg"> Congo </option>
                <option value="ck"> Cook Islands </option>
                <option value="cr"> Costa Rica </option>
                <option value="ci"> Cote D\'Ivoire </option>
                <option value="hr"> Croatia </option>
                <option value="cu"> Cuba </option>
                <option value="cy"> Cyprus </option>
                <option value="cz"> Czech Republic </option>
                <option value="dk"> Denmark </option>
                <option value="dj"> Djibouti </option>
                <option value="dm"> Dominica </option>
                <option value="do"> Dominican Republic </option>
                <option value="tl"> East Timor </option>
                <option value="ec"> Ecuador </option>
                <option value="eg"> Egypt </option>
                <option value="sv"> El Salvador </option>
                <option value="gq"> Equatorial Guinea </option>
                <option value="er"> Eritrea </option>
                <option value="ee"> Estonia </option>
                <option value="et"> Ethiopia </option>
                <option value="fk"> Falkland Islands </option>
                <option value="fo"> Faroe Islands </option>
                <option value="fj"> Fiji </option>
                <option value="fi"> Finland </option>
                <option value="fr"> France </option>
                <option value="gf"> French Guiana </option>
                <option value="pf"> French Polynesia </option>
                <option value="tf"> French Southern Territories </option>
                <option value="ga"> Gabon </option>
                <option value="gm"> Gambia </option>
                <option value="ps"> Gaza Strip, West Bank </option>
                <option value="ge"> Georgia </option>
                <option value="de"> Germany </option>
                <option value="gh"> Ghana </option>
                <option value="gi"> Gibraltar </option>
                <option value="gr"> Greece </option>
                <option value="gl"> Greenland </option>
                <option value="gd"> Grenada </option>
                <option value="gp"> Guadeloupe </option>
                <option value="gu"> Guam </option>
                <option value="gt"> Guatemala </option>
                <option value="gn"> Guinea </option>
                <option value="gw"> Guinea-Bissau </option>
                <option value="gy"> Guyana </option>
                <option value="ht"> Haiti </option>
                <option value="hm"> Heard and McDonald Islands </option>
                <option value="va"> Vatican City State </option>
                <option value="hn"> Honduras </option>
                <option value="hk"> Hong Kong </option>
                <option value="hu"> Hungary </option>
                <option value="is"> Iceland </option>
                <option value="id"> Indonesia </option>
                <option value="ir"> Iran </option>
                <option value="iq"> Iraq </option>
                <option value="ie"> Ireland </option>
                <option value="il"> Israel </option>
                <option value="it"> Italy </option>
                <option value="jm"> Jamaica </option>
                <option value="jp"> Japan </option>
                <option value="jo"> Jordan </option>
                <option value="kz"> Kazakhstan </option>
                <option value="ke"> Kenya </option>
                <option value="ki"> Kiribati </option>
                <option value="kp"> South Korea </option>
                <option value="kr"> North Korea </option>
                <option value="kw"> Kuwait </option>
                <option value="kg"> Kyrgyzstan </option>
                <option value="la"> Laos </option>
                <option value="lv"> Latvia </option>
                <option value="lb"> Lebanon </option>
                <option value="ls"> Lesotho </option>
                <option value="lr"> Liberia </option>
                <option value="ly"> Libyan Arab Jamahiriya </option>
                <option value="li"> Liechtenstein </option>
                <option value="lt"> Lithuania </option>
                <option value="lu"> Luxembourg </option>
                <option value="mo"> Macao </option>
                <option value="mk"> Macedonia </option>
                <option value="mg"> Madagascar </option>
                <option value="mw"> Malawi </option>
                <option value="my"> Malaysia </option>
                <option value="mv"> Maldives </option>
                <option value="ml"> Mali </option>
                <option value="mt"> Malta </option>
                <option value="mh"> Marshall Islands </option>
                <option value="mq"> Martinique </option>
                <option value="mr"> Mauritania </option>
                <option value="mu"> Mauritius </option>
                <option value="yt"> Mayotte </option>
                <option value="mx"> Mexico </option>
                <option value="fm"> Micronesia </option>
                <option value="md"> Moldova, Republic of </option>
                <option value="mc"> Monaco </option>
                <option value="mn"> Mongolia </option>
                <option value="ms"> Montserrat </option>
                <option value="ma"> Morocco </option>
                <option value="mz"> Mozambique </option>
                <option value="mm"> Myanmar </option>
                <option value="na"> Namibia </option>
                <option value="nr"> Nauru </option>
                <option value="np"> Nepal </option>
                <option value="nl"> Netherlands </option>
                <option value="an"> Netherlands Antilles </option>
                <option value="nc"> New Caledonia </option>
                <option value="nz"> New Zealand </option>
                <option value="ni"> Nicaragua </option>
                <option value="ne"> Niger </option>
                <option value="ng"> Nigeria </option>
                <option value="nu"> Niue </option>
                <option value="nf"> Norfolk Island </option>
                <option value="mp"> Northern Mariana Islands </option>
                <option value="no"> Norway </option>
                <option value="om"> Oman </option>
                <option value="pk"> Pakistan </option>
                <option value="pw"> Palau </option>
                <option value="pa"> Panama </option>
                <option value="pg"> Papua New Guinea </option>
                <option value="py"> Paraguay </option>
                <option value="pe"> Peru </option>
                <option value="ph"> Philippines </option>
                <option value="pn"> Pitcairn </option>
                <option value="pl"> Poland </option>
                <option value="pt"> Portugal </option>
                <option value="pr"> Puerto Rico </option>
                <option value="qa"> Qatar </option>
                <option value="re"> Reunion </option>
                <option value="ro"> Romania </option>
                <option value="ru"> Russian Federation </option>
                <option value="rw"> Rwanda </option>
                <option value="gs"> S. Georgia and S. Sandwich Isles. </option>
                <option value="sh"> Saint Helena </option>
                <option value="kn"> Saint Kitts and Nevis Anguilla </option>
                <option value="lc"> Saint Lucia </option>
                <option value="pm"> Saint Pierre and Miquelon </option>
                <option value="vc"> Saint Vincent and Grenadines </option>
                <option value="ws"> Samoa </option>
                <option value="sm"> San Marino </option>
                <option value="st"> Sao Tome and Principe </option>
                <option value="sa"> Saudi Arabia </option>
                <option value="sn"> Senegal </option>
                <option value="sc"> Seychelles </option>
                <option value="sl"> Sierra Leone </option>
                <option value="sg"> Singapore </option>
                <option value="sk"> Slovakia </option>
                <option value="si"> Slovenia </option>
                <option value="sb"> Solomon Islands </option>
                <option value="so"> Somalia </option>
                <option value="za"> South Africa </option>
                <option value="es"> Spain </option>
                <option value="lk"> Sri Lanka </option>
                <option value="sd"> Sudan </option>
                <option value="sr"> Suriname </option>
                <option value="sj"> Svalbard and Jan Mayen </option>
                <option value="sz"> Swaziland </option>
                <option value="se"> Sweden </option>
                <option value="ch"> Switzerland </option>
                <option value="sy"> Syrian Arab Republic </option>
                <option value="tw"> Taiwan </option>
                <option value="tj"> Tajikistan </option>
                <option value="tz"> Tanzania </option>
                <option value="th"> Thailand </option>
                <option value="tg"> Togo </option>
                <option value="tk"> Tokelau </option>
                <option value="to"> Tonga </option>
                <option value="tt"> Trinidad and Tobago </option>
                <option value="tn"> Tunisia </option>
                <option value="tr"> Turkey </option>
                <option value="tm"> Turkmenistan </option>
                <option value="tc"> Turks and Caicos Islands </option>
                <option value="tv"> Tuvalu </option>
                <option value="ug"> Uganda </option>
                <option value="ua"> Ukraine </option>
                <option value="ae"> United Arab Emirates </option>
                <option value="gb"> United Kingdom </option>
                <option value="um"> U. S. Minor Outlying Islands </option>
                <option value="uy"> Uruguay </option>
                <option value="uz"> Uzbekistan </option>
                <option value="vu"> Vanuatu </option>
                <option value="ve"> Venezuela </option>
                <option value="vn"> Viet Nam </option>
                <option value="vg"> Virgin Islands, British </option>
                <option value="vi"> Virgin Islands, U.S. </option>
                <option value="wf"> Wallis and Futuna Islands </option>
                <option value="eh"> Western Sahara </option>
                <option value="yu"> Yemen </option>
                <option value="yu"> Yugoslavia </option>
                <option value="zm"> Zambia </option>
                <option value="zw"> Zimbabwe </option>
              </select> </td>
            <td><select name="l" size="4" multiple>
                <option selected>Select Location</option>
              </select></td>
            <td><input type="submit" name="s" value="Search" onClick="submitForm(this);"></td>
          </tr>
		  
          
        </table></td></tr>'; 
print "$documentBuffer";

print "<br>pagetype:$pagetype\n";
print "<br>option:$query_option<br>sort:$sortby<br>links:$nolinks<br>size:$size<br>rowcount:$row_count<br>\n";
my (@key1,$key2);
if ($pagetype eq 'MAIN'){
($key2) = &prepareKeywords($querytext,\@key1);
#&checkresults(\@key1,$location);
&checkresults(\@key1,$location,$offset,$row_count,$query_option,$sortby,$nolinks,$size);
}
elsif ($pagetype eq 'RESULT'){
  # &getresults($catid,$keypat,$location,$res_count,$offset,$row_count);
   &getresults($catid,$keypat,$location,$res_count,$offset,$row_count,$sortby,$nolinks,$size,$keycnt,$query_option);
}
else
{
  @key1 = $q->param("catbox");
  #&checkresults(\@key1,$location,$offset,$row_count);
  &checkresults(\@key1,$location,$offset,$row_count,$query_option,$sortby,$nolinks,$size);
}

$documentBuffer = '<tr><td colspan="3"><table align="center">
  <tr><td><img src="/images/spacer.gif" width = "100%" height=20></td></tr>
  <tr>
        <td>
                <a href="http://69.59.182.204/index29.html">Home</a>
                <a href="http://69.59.182.204/aboutus.htm">About Ishtaar</a>
                <a href="http://69.59.182.204/contactus.htm">Contact Us</a>
                <a href="http://69.59.182.204/disclaimer.htm">Disclaimer</a>
                </td>
        </tr>
                <tr>
        <td align="center"><font size=-2>&copy;2003 Ishtaar - All rights reserved.</font></p>
        </td>

  </tr>
   
   </table>
   </td></tr>
  </TBODY>
</TABLE>
</td></tr>
</table>

</body>
</html>';

print $documentBuffer;
