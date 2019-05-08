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

print "Content-type:text/html\n\n";
my ($str) = '<html>
<head>
<title>Ishtaar: International Software, Human Capital, Technology And Advanced Resources</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript1.2" src="location.js" type="text/JavaScript1.2"></script>
<script language="javascript" type="text/javascript">
function setFocus(){document.f.q.focus();}
function Help( daLink ) {
	var comwin = window.open(daLink,"Help","width=560,height=450,scrollbars=yes,resize=no");
	    comwin.focus() ;	    }
function submitForm(obj ) {
    var l = obj
	var len = document.f.l.options.length
	 if (l.value == "Advanced Search")
	{
      
	 location.href = "/adv_search.html"
	 }
	if (l.value == "Search" )
	{
	   document.f.lindex.value = len
	   document.f.action = "/cgi-bin/search.pl";
	   document.f.submit();
	   return true;
	 }
	
}
</script>
<style type="text/css">
<!--
/* being basic styles */
	body {font-family: arial, helvetica, sans-serif; font-size: 10pt; background-color: #FFFFFF; margin-left:0; margin-top:0; margin-right:0}
	table, td {font-family: arial, helvetica, sans-serif; font-size: 10pt; color: #000000}
	.coloredheader {font-family: arial, helvetica, sans-serif; font-size: 13pt; color: #000000; font-weight: bold}
	.header {font-family: arial, helvetica, sans-serif; font-size: 13pt; color: #000000; font-weight: bold}
	.subhead {font-family: arial, helvetica, sans-serif; font-size: 11pt; color: #000000}
	.bodytext {font-family: arial, helvetica, sans-serif; font-size: 10pt;}
	.small {font-family: arial, helvetica, sans-serif; font-size: 9pt; color: #000000}
	.small_colored {font-size: 9pt; color: #990000; font-family: arial, helvetica, sans-serif}
	.smaller {font-family: arial, helvetica, sans-serif; font-size: 11px; color: #000000}
	.lightsmaller {font-family: arial, helvetica, sans-serif; font-size: 11px; color: #666666}
	.formtext {font-family: courier, monospace}
	.greybold {font-family: arial, helvetica, sans-serif; font-size: 10pt; color: 333333; font-weight: bold}
	.greysmaller {font-family: arial, helvetica, sans-serif; font-size: 11px; color: #333333; font-weight: bold}
	p, div {font-family: arial, helvetica, sans-serif; font-size: 10pt; color: #000000}
	a:link {color: #113456}
	a:visited {color: #477AB8}
	a:active {color: #C00}
        a.whitelink:link {color: #000}
        a.whitelink:visited {color: #000}
        a.whitelink:active {color: #000}
        a.smallerwhitelink:link {color: #FFF; font-size: 11px}
        a.smallerwhitelink:visited {color: #FFF; font-size: 11px}
        a.smallerwhitelink:active {color: #FFF; font-size: 11px}
        a.gray:link {color: #666; font-size: 11px}
        a.gray:visited {color: #666; font-size: 11px}
        a.gray:active {color: #666; font-size: 11px}
/* other font types */
	.titletext {font-family: arial, helvetica, sans-serif; font-size: 10pt; color: #FF6600}
	.companytext {font-family: arial, helvetica, sans-serif; font-size: 15pt;}
	.bluetext {font-family: arial, helvetica, sans-serif; font-size: 11pt; color: #3366CC }
	.bluetextbold {font-family: arial, helvetica, sans-serif; font-size: 12pt; color: #3366CC; font-weight: bold}
    .bluetextsmall {font-family: arial, helvetica, sans-serif; font-size: 11px; color: #3366CC}
	.linktext {font-family: arial, helvetica, sans-serif; font-size: 9pt; color: #000000}
	.blueheader {font-family: arial, helvetica, sans-serif; font-size: 13pt; color: #039; font-weight: bold}
	.lightblueheader {font-family: arial, helvetica, sans-serif; font-size: 14pt; color: B6C6D9;}
	.whiteheader {font-family: arial, helvetica, sans-serif; font-size: 13pt; color: #FFFFFF; font-weight: bold}
	.bwheader {font-family: arial, helvetica, sans-serif; font-size: 13pt; color: T_COLOR_FONT; font-weight: bold}
	.whitetext {font-family: arial, helvetica, sans-serif; font-size: 10pt; color: #FFFFFF}
	.bwtext {font-family: arial, helvetica, sans-serif; font-size: 10pt; color: T_COLOR_FONT}
	.whitesmall {font-family: arial, helvetica, sans-serif; font-size: 9pt; color: #FFFFFF}
	.bwsmall {font-family: arial, helvetica, sans-serif; font-size: 9pt; color: T_COLOR_FONT}
	.whitesmaller {font-family: arial, helvetica, sans-serif; font-size: 11px; color: #FFFFFF}
	.bwsmaller {font-family: arial, helvetica, sans-serif; font-size: 11px; color: T_COLOR_FONT}
    	.highlight {background: #6D8CB3; color: #FFFFFF;}
    	.errortext {font-family: arial, helvetica, sans-serif; font-size: 10pt; color: #FF0000; font-weight: bold; text-align: center}

/* other td types */
	.black {background-color: #000000}
	.darker {background-color: #6D8CB3}
	.dark {background-color: #6D8CB3}
	.medium {background-color: #CCCCCC}
	.lightmedium {background-color: #DDDDDD}
	.light {background-color: #EEEEEE}
	.yellow {background-color: #FCD970}
	.lightyellow {background-color: #FDF8D4} /* old FFF6C0 */
	.lighteryellow {background-color: #FDF8D4}
	.blue {background-color: #8CA6F7}
	.lightblue {background-color: #99B7DD}
	.lighterblue {background-color: #EEEEEE}
	.white {background-color: #FFFFFF}
    	.corpblue {background-color: #6D8CB3}
    	.corplightblue {background-color: #99B7DD}
	.h1 { font-family: verdana,arial,helvetica,sans-serif; color: #CC6600; font-size: small; }

/* left menu navigation links*/
	a.selectedMenuItem:active{font-family: arial, helvetica, sans-serif; font-size: 11px; color: #3366CC; text-decoration:none; font-weight : bold;}
	a.selectedMenuItem:link{font-family: arial, helvetica, sans-serif; font-size: 11px; color: #3366CC; text-decoration:none; font-weight : bold;}
	a.selectedMenuItem:visited{font-family: arial, helvetica, sans-serif; font-size: 11px; color: #3366CC; text-decoration:none; font-weight : bold;}
	a.selectedMenuItem:hover{font-family: arial, helvetica, sans-serif; font-size: 11px; color: #3366CC; text-decoration : underline; font-weight : bold;}
	a.MenuItem:active{font-family: arial, helvetica, sans-serif; font-size: 11px; color: #333333; text-decoration:none; font-weight : bold; }
	a.MenuItem:link{font-family: arial, helvetica, sans-serif; font-size: 11px; color: #333333; text-decoration:none; font-weight : bold;}
	a.MenuItem:visited{font-family: arial, helvetica, sans-serif; font-size: 11px; color: #333333; text-decoration:none; font-weight : bold;}
	a.MenuItem:hover{font-family: arial, helvetica, sans-serif; font-size: 11px; color: #333333; text-decoration : underline; font-weight : bold;}
/* corp website links*/
    .news {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; font-weight: bold; color: #333333;}
.newstext {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; font-weight: normal; font-style: italic; color: #000000;}
a.newstext {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; font-weight: normal; font-style: italic; color: #000000;}
a:visited.newstext {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; font-weight: normal; font-style: italic; color:
#000000;}
.pageheader {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 16pt; font-weight: bolder; color: #003366;}
.subheader {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12pt; font-weight: bolder; color: #232F44;}
.subsubheaderCopy {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; font-weight: bold; color: #232F44; font-style: normal; text-decoration: none}
.bodyboldital {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; font-weight: bold; color: #000000; font-style: italic;}
.bodycopy {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; font-weight: normal; color: #000000; font-style: normal;}
.bodyboldCopy {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; font-weight: bold; color: #003366; font-style: normal; text-decoration: none;}
.bodyboldCopy:hover {font-family: Verdana, Arial, Helvetica, sans-serif;	font-size: 8pt;	font-weight: bold;	color: #FF0000;	font-style: normal;	text-decoration: none;}
.bodyCopy:hover {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; font-weight: bold; color: #FF0000; font-style: normal; text-decoration: none;}
.fineprint:hover {font-family: Verdana, Arial, Helvetica, sans-serif;	font-size: 8pt;	font-weight: bold;	color: #FF0000;	font-style: normal;	text-decoration: none;}
.newstext:hover {font-family: Verdana, Arial, Helvetica, sans-serif;	font-size: 8pt;	font-weight: bold; color: #FF0000;	font-style: normal;	text-decoration: none;}
.bodyboldital:hover {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; font-weight: bold; color: #FF0000; font-style: normal; text-decoration: none;}
.fineprint {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; color: #829AC0; text-decoration: none;}
.vblue {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; color: #5C6697; font-weight: bold}
.vbluesm {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; color: #5C6697; font-weight: norma; text-decoration: none}
.tablenav1 { font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #344465; background-color: #BCC7DD; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; font-weight: bold; line-height: 21px; text-decoration: none;}
a.tablenav1 { font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #344465; background-color: #BCC7DD; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; font-weight: bold; line-height: 21px; text-decoration: none;}
a:hover.tablenav1 {text-decoration: none; font-family: Arial, Helvetica, sans-serif; font-size: 11px; color:#EBEEF5; font-weight: bold; background:#344465; width:175; padding:0}}
.tablenav2 { font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #973534; background-color: #FFFFFF; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; font-weight: bold; line-height: 21px; text-decoration: none;}
.subheader2 { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12pt; font-weight: bolder; color: #000000; }
.tablenav3 { font-family: Arial, Helvetica, sans-serif; font-size: 10px; color: #FFFFFF; background-color: #324565; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; font-weight: bold; line-height: 21px; text-decoration: none;}
a.tablenav3 { font-family: Arial, Helvetica, sans-serif; font-size: 10px; color: #FFFFFF; background-color: #324565; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; font-weight: bold; line-height: 21px; text-decoration: none;}
a:visited.tablenav3 { font-family: Arial, Helvetica, sans-serif; font-size: 10px; color: #FFFFFF; background-color: #324565; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; font-weight: bold; line-height: 21px; text-decoration: none;}
a:hover.tablenav3 { font-family: Arial, Helvetica, sans-serif; font-size: 10px; color: #973534; background-color: #FFFFFF; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; font-weight: normal; line-height: 21px; width:155; text-decoration: none; }
.attn { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 18px; font-weight: bold; font-variant: small-caps; color: #CCFF00; background-color: #990000}
.up1 { top: -17px; clip:  rect(   )}
.bodyboldCopysmlink { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; font-weight: normal; color: #003366; font-style: normal; text-decoration: none; }
a.bodyboldCopysmlink { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; font-weight: normal; color: #003366; font-style: normal; text-decoration: none; }
A:hover.bodyboldCopysmlink { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; font-weight: normal; color: #FF0000; font-style: normal; text-decoration: none; }
.bodycopybold { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; font-weight: bold; color: #000000; font-style: normal; }
.bodyboldCopysmlinkHot { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; font-weight: bold; color: #990000; font-style: normal; text-decoration: none; }
	-->
</style>


</head>
<body leftmargin="0" topmargin="0" marginheight="0" marginwidth="0" link=#0000cc vlink=#551a8b alink=#ff0000 onLoad=setFocus()>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr><td>

<table align="center">
  <tr><td><img src="images\spacer.gif" width = "100%" height=20></td></tr>
  <tr>
        <td align="center"><img src="images\ishtaarlogo.png" width=80 height=50 alt="ISHTAAR"></td>
	</tr>
		<tr>
        <td height="25" class="companytext" ><font color="#0000FF">I</font>nternational 
          <font color="#CC0000">S</font>oftware, <font color="#0000FF">H</font>uman 
          Capital, <font color="#CC0000">T</font>echnology <font color="#0000FF">A</font>nd 
          <font color="#CC0000">A</font>dvanced <font color="#0000FF">R</font>esources 
        </td>

  </tr>
   <tr><td><img src="images\spacer.gif" width = "100%" height=10></td></tr>
   </table>
       <form  name=f METHOD=GET>
      <table  align="center">
	 
        <tr> 
          <td height="23" class="bluetext">Enter Keywords (Category, Skill)</td>
          <td><img src="images\spacer.gif" width = "25" height=11></td>
          <td class="bluetext">Country</td>
          <td><img src="images\spacer.gif" width = "25" height=11></td>
          <td class="bluetext">City/Province/Region:</td>
        </tr>
        <input type="hidden" name="fr" value=0>
        <input type="hidden" name="rc" value=10>
        <input type="hidden" value="" name="lindex">
        <input type="hidden" value="MAIN" name="pt">
		 <input type="hidden" value="r" name="so">
		 <input type="hidden" value=5 name="nl">
        <tr valign="top">
          <td ><input type="text" name="q" size="35" maxlength="255" value=""></td>
          <td><img src="images\spacer.gif" width = "5" height=11></td>
          <td> <select size="1" name="c" onChange="locationDrop(this)">
              <option value="ALL"> NO PREFERENCE </option>
              <option value="us" selected> United States </option>
              <option value="ca"> Canada </option>
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
              <option value="cn"> China </option>
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
              <option value="in"> India </option>
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
          <td><img src="images\spacer.gif" width = "5" height=11></td>
          <td><select size="4" name="l" multiple>
              <option selected>Select Location</option>
            </select></td>
          <td><img src="images\spacer.gif" width = "5" height=11></td>
          <td><input type="submit" name="s" value="Search" onClick="submitForm(this);"></td>
        </tr>
        <tr>
          <td><img src="images\spacer.gif" width = "100%" height=5></td>
        </tr>
      </table>
 <table align="center" cellspacing="0" cellspadding="0">
 <tr>
            <td><input type=submit value="Advanced Search" name="as"> 
              <input type=submit value="Register Your Firm" name="rf">
 </td></tr></table> 
  </form>
 <table width="90%" border="0" cellspacing="10" cellpadding="0" align="left">	
						<tr>
						   
                          <td colspan="2" class="bluetextbold" valign="bottom">Browse Categories:
					       </td>
						 </tr>
						<tr>
						<td width="34%" valign="top" class="bluetextheader"><br><a href="/cgi-bin/searchbycategory.pl?cid=1005"><b>Global Partnerships</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=8">Call Center</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=27">Bpo</a> &nbsp;<a href="/cgi-bin/searchbycategory.pl?cid=87">Ites</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1001"><b>Health Care Administration</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=1">Medical Transcription</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=9">Health Care</a> &nbsp;<a href="/cgi-bin/searchbycategory.pl?cid=66">Hospital Management</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1006"><b>Application Software</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=4">Crm</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=20">Erp</a> &nbsp;<a href="/cgi-bin/searchbycategory.pl?cid=52">Document Management</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1007"><b>System Software & Tools</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=33">Embedded Systems</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=73">Advanced Programming</a> &nbsp;<a href="/cgi-bin/searchbycategory.pl?cid=75">System Programming</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=78">Device Drivers</a> &nbsp;<a href="/cgi-bin/searchbycategory.pl?cid=104">Programming Languages</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=109">Operating Systems</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1008"><b>Enterprise</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=5">Eai</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=20">Erp</a> &nbsp;<a href="/cgi-bin/searchbycategory.pl?cid=99">Business Integration Technologies</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1002"><b>Finance, Banking & Equity</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=17">Financial Services</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=21">Banking</a> &nbsp;<a href="/cgi-bin/searchbycategory.pl?cid=37">Stock</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=56">Fund Management</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1004"><b>Web Design</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=107">Web Authoring Tools</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1010"><b>Internet Technologies</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=67">Web Services</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=100">Application Servers/servlets</a> &nbsp;<a href="/cgi-bin/searchbycategory.pl?cid=101">Microsoft Web Technologies</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=102">J2ee Technologies</a> &nbsp;<a href="/cgi-bin/searchbycategory.pl?cid=103">Other Web Technologies</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=106">Web Servers</a> &nbsp;<a href="/cgi-bin/searchbycategory.pl?cid=108">Messaging</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1014"><b>Ecommerce</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=6">B2c</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=32">Ecommerce</a> &nbsp;<a href="/cgi-bin/searchbycategory.pl?cid=70">B2b</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=94">B2b Technologies</a> &nbsp;</td><td width="34%" valign="top" class="bluetextheader"><br><a href="/cgi-bin/searchbycategory.pl?cid=1013"><b>Database & Storage</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=72">Storage Management</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=105">Database</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1019"><b>Content Management & Publishing</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=58">Content Management</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=97">Content Management Technologies</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1021"><b>Inventory & Materials Management</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=12">Inventory Management</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=14">Order Management</a> &nbsp;<a href="/cgi-bin/searchbycategory.pl?cid=53">Materials Management</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=92">Planning And Forecasting</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1023"><b>Collaboration and knowledge</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=11">Workflow Management</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=42">Groupware</a> &nbsp;<a href="/cgi-bin/searchbycategory.pl?cid=52">Document Management</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=69">Knowledge Management</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1018"><b>Transportation</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=40">Fleet Management</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=54">Logistics</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1011"><b>Business Intelligence</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=61">Business Intelligence</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=98">Data Warehousing & mining Technologies</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1009"><b>HRM Solutions</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=10">Recruiting</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1012"><b>Life Sciences</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=29">Biotechnology</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=96">Image Processing</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1016"><b>Communication</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=48">Networking</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=51">Ip Telephony</a> &nbsp;<a href="/cgi-bin/searchbycategory.pl?cid=44">Vop</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1015"><b>Wireless</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=49">Wireless Networking</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=64">Mobile Commerce</a> &nbsp;<a href="/cgi-bin/searchbycategory.pl?cid=91">Wireless Messaging</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=95">Wireless Communication Systems</a> &nbsp;</td><td width="34%" valign="top" class="bluetextheader"><br><a href="/cgi-bin/searchbycategory.pl?cid=1017"><b>Voice Technologies</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=28">Speech Recognition</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1025"><b>Network Management</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=34">Telecom Solutions</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=46">Vpn</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1024"><b>Hosting Services</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=7">Web Hosting</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1022"><b>Geographic Systems</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=47">Gps</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=65">Geography</a> &nbsp;<a href="/cgi-bin/searchbycategory.pl?cid=90">Geographic Systems</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1026"><b>Digital Media</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=43">Digital Media</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=62">Video</a> &nbsp;<a href="/cgi-bin/searchbycategory.pl?cid=68">Imaging</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1003"><b>Engineering & Manufacturing</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=22">Cad</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=24">Eda</a> &nbsp;<a href="/cgi-bin/searchbycategory.pl?cid=74">Manufacturing</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1027"><b>Security</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=85">Security</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1028"><b>Quality Assurance</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=25">Quality Certification</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=60">Web Testing</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1020"><b>Software Engineering</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=25">Quality Certification</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=30">Software Maintenance</a> &nbsp;<a href="/cgi-bin/searchbycategory.pl?cid=71">Methodologies</a> &nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=80">Software Engineering</a> &nbsp;</td>
	
						</tr></table>
	
</td></tr> </table> 

</body>
</html>';
print "$str";
