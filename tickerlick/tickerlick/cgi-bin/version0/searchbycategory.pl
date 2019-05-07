#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: searchbycategory.pl
#Date started : 11/20/03
#Last Modified : 11/20/03
#Purpose : Query page: Display selected categories and search criteria
#use lib qw(/home/tthaliat/httpd/wwwdev/perl);
$| = 1;
use strict;
use CGI qw(:standard); 
my ($q) = new CGI;
my ($location,$querytext,$offset,$catid,$row_count,$l,$keypat,$res_count);
print "Content-type:text/html\n\n";
require "cr_category_webdata.pl";
#get all the form variable values

 $catid = $q->param("cid");
  
my ($documentBuffer) = '<html>
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
           document.f.pt.value = "CATEGORY"; 
           document.f.action = "/cgi-bin/search.pl";
           document.f.submit();
           return true;
         }
        }
        if (o.name == "s"){
        if (o.value == "Search")
        {
           document.f.pt.value = "MAIN";
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
<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr><td>

<table align="center">
  <tr><td><img src="/images/spacer.gif" width = "100%" height=10></td></tr>
  <tr>
        <td align="center"><img src="/images/ishtaarlogo.png" width=80 height=50 alt="ISHTAAR"></td>
	</tr>
		<tr>
        <td height="25" class="companytext" ><font color="#0000FF">I</font>nternational 
          <font color="#CC0000">S</font>oftware, <font color="#0000FF">H</font>uman 
          Capital, <font color="#CC0000">T</font>echnology <font color="#0000FF">A</font>nd 
          <font color="#CC0000">A</font>dvanced <font color="#0000FF">R</font>esources 
        </td>

  </tr>
   <tr><td><img src="/images/spacer.gif" width = "100%" height=10></td></tr>
   </table>
      <table align="center" cellspacing="0" cellspadding="0">
 <tr>
            
          <td><a href="http://69.59.182.204/index29.html">Home</a>&nbsp;&nbsp;<a href="http://69.59.182.204/checkyourfirm.html";>Register 
            Your firm</a></td>
        </tr></table>
       <form  name=f METHOD=GET>
      <table  align="center">
	 
        <tr> 
          <td height="23" class="bluetext">Enter Keywords (Category, Skill)</td>
          <td><img src="/images/spacer.gif" width = "25" height=11></td>
          <td class="bluetext">Country</td>
          <td><img src="/images/spacer.gif" width = "25" height=11></td>
          <td class="bluetext">City/Province/Region:</td>
        </tr>
        <input type="hidden" name="fr" value=0>
        <input type="hidden" name="rc" value=10>
        <input type="hidden" value="" name="lindex">
        <input type="hidden" value="" name="pt">
		 <input type="hidden" value="r" name="so">
		 <input type="hidden" value=5 name="nl">
        <tr valign="top">
          <td ><input type="text" name="q" size="35" maxlength="255" value=""></td>
          <td><img src="/images/spacer.gif" width = "5" height=11></td>
          <td> <select name="c" size="4" onChange="locationDrop(this,document.f.l)">
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
          <td><img src="/images/spacer.gif" width = "5" height=11></td>
          <td><select name="l" size="4" multiple>
              <option selected>Select Location</option>
            </select></td>
          <td><img src="/images/spacer.gif" width = "5" height=11></td>
          <td><input type="submit" name="s" value="Search" onClick="submitForm(this);"></td>
        </tr>
        <tr>
          <td><img src="/images/spacer.gif" width = "100%" height=5></td>
        </tr>
      </table><br>
	
    <tr><td><table cellpadding="0" cellspacing="0" width="68%" align="center">
        <tr> 
          <td height="25" class="bluetextbold" align="left">Advanced Search Options</td>
          </tr>
		  </table>
		
		  <table align="center" width="68%" border="1"  cellpadding="1" cellspacing="0"><tr><td>
		  <table border="0"  cellpadding="1" cellspacing="0" width="100%" align="center">
                <tr>
                  <td><img src="/images/spacer.gif" width = "5" height=10></td>
                </tr>
                <tr> 
                  <td><font class="bluetext">Find Results</font>&nbsp;&nbsp;&nbsp; 
                    <select size="1" name="q_0" >
                      <option value="1">with all of the words</option>
                      <option value="2" selected>with any of the words</option>
                      <option value="3">with the exact phrase</option>
                    </select> </td>
                  <td><font class="bluetext">Sort By</font>&nbsp;&nbsp;&nbsp; 
                    <select size="1" name="so" >
                      <option selected value="R">Relevance</option>
                      <option value="L">Location</option>
                    </select></td>
                  <td><font class="bluetext">No. Of Results/Page</font>&nbsp;&nbsp;&nbsp; 
                    <select size="1" name="rc" >
                      <option selected value="10">10</option>
                      <option value="20">20</option>
                      <option value="30">30</option>
                    </select></td>
                </tr>
                
                <tr> 
                  <td><img src="/images/spacer.gif" width = "100%" height=20></td>
                </tr>
				

                 <tr><td><font class="bluetext">Show</font>&nbsp;&nbsp;
				         <select size="1" name="nl" >
                         <option selected value="5">5 Links </option>
			             <option value="3">3 Links</option>
			             <option value="0">No Links</option>
                       </select><font class="bluetext">&nbsp;&nbsp;For Each Result</font></td>

                   <td><font class="bluetext">Select</font>&nbsp;&nbsp;
				       <select size="1" name="cs" >
                       <option selected value="all">All Firms</option>
			           <option value="l">Large Firms</option>
			           <option value="m">Medium Firms</option>
			           <option value="s">Small Firms</option>
                     </select></td>
                  </tr>
				  <tr><td><img src="/images/spacer.gif" width = "100%" height=10></td></tr>
      
 </table>
</td></tr></table>';
	    
print "$documentBuffer\n";

&getcategories($catid);
$documentBuffer = '<table cellpadding="0" cellspacing="0" width="68%" align="center">
        <tr>
        <td class="bluetextbold" align="left" valign="top">Browse Categories</td>
          </tr>
<tr><td width="35%" valign="top" class="bluetextheader"><a 

href="/cgi-bin/searchbycategory.pl?cid=1005"><b>Global Partnerships</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=8">Call Center</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=27">BPO</a> &nbsp;<a 

href="/cgi-bin/searchbycategory.pl?cid=87">ITES</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=13">Transcription</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1001"><b>Health Care Administration</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=1">Medical Transcription</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=9">Health Care</a> &nbsp;<a 

href="/cgi-bin/searchbycategory.pl?cid=66">Hospital Management</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1006"><b>Application Software</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=4">CRM</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=20">ERP</a> &nbsp;<a 

href="/cgi-bin/searchbycategory.pl?cid=52">Document Management</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1007"><b>System Software & Tools</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=33">Embedded Systems</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=73">Advanced Programming</a> &nbsp;<a 

href="/cgi-bin/searchbycategory.pl?cid=75">System Programming</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=78">Device Drivers</a> &nbsp;<a 

href="/cgi-bin/searchbycategory.pl?cid=104">Programming Languages</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=109">Operating Systems</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1008"><b>Enterprise</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=5">EAI</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=20">ERP</a> &nbsp;<a 

href="/cgi-bin/searchbycategory.pl?cid=99">Business Integration Technologies</a> 

&nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=111">IBM Platforms</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1002"><b>Finance, Banking & Equity</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=17">Financial Services</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=21">Banking</a> &nbsp;<a 

href="/cgi-bin/searchbycategory.pl?cid=37">Stock</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=56">Fund Management</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1004"><b>Web Design</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=107">Web Authoring Tools</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1010"><b>Internet Technologies</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=67">Web Services</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=100">Application Servers/Servlets</a> &nbsp;<a 

href="/cgi-bin/searchbycategory.pl?cid=101">Microsoft Web Technologies</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=102">J2EE Technologies</a> &nbsp;<a 

href="/cgi-bin/searchbycategory.pl?cid=103">Other Web Technologies</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=106">Web Servers</a> &nbsp;<a 

href="/cgi-bin/searchbycategory.pl?cid=108">Messaging</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1014"><b>Ecommerce</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=6">B2C</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=32">Ecommerce</a> &nbsp;<a 

href="/cgi-bin/searchbycategory.pl?cid=70">B2B</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=94">B2B Technologies</a> &nbsp;</td><td width="34%" 

valign="top" class="bluetextheader"><br><a 

href="/cgi-bin/searchbycategory.pl?cid=1013"><b>Database & Storage</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=72">Storage Management</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=105">Database</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1019"><b>Content Management & 

Publishing</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=58">Content Management</a> 

&nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=97">Content Management Technologies</a> 

&nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1021"><b>Inventory & Materials 

Management</b></a><br><a href="/cgi-bin/searchbycategory.pl?cid=12">Inventory Management</a> 

&nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=14">Order Management</a> &nbsp;<a 

href="/cgi-bin/searchbycategory.pl?cid=53">Materials Management</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=92">Planning And Forecasting</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1023"><b>Collaboration and knowledge</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=11">Workflow Management</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=42">Groupware</a> &nbsp;<a 

href="/cgi-bin/searchbycategory.pl?cid=52">Document Management</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=69">Knowledge Management</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1018"><b>Transportation</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=40">Fleet Management</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=54">Logistics</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1011"><b>Business Intelligence</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=61">Business Intelligence</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=98">Data Warehousing & Mining Technologies</a> 

&nbsp;<br><a href="/cgi-bin/searchbycategory.pl?cid=1009"><b>HRM Solutions</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=10">Recruiting</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1012"><b>Life Sciences</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=29">Biotechnology</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=96">Image Processing</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1016"><b>Communication</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=48">Networking</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=51">IP Telephony</a> &nbsp;<a 

href="/cgi-bin/searchbycategory.pl?cid=44">VOP</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1015"><b>Wireless</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=49">Wireless Networking</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=64">Mobile Commerce</a> &nbsp;<a 

href="/cgi-bin/searchbycategory.pl?cid=91">Wireless Messaging</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=95">Wireless Communication Systems</a> &nbsp;</td><td 

width="34%" valign="top" class="bluetextheader"><br><a 

href="/cgi-bin/searchbycategory.pl?cid=1017"><b>Voice Technologies</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=28">Speech Recognition</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1025"><b>Network Management</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=34">Telecom Solutions</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=46">VPN</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1024"><b>Hosting Services</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=7">Web Hosting</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1022"><b>Geographic Systems</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=47">GPS</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=65">Geography</a> &nbsp;<a 

href="/cgi-bin/searchbycategory.pl?cid=90">Geographic Systems</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1026"><b>Digital Media</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=43">Digital Media</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=62">Video</a> &nbsp;<a 

href="/cgi-bin/searchbycategory.pl?cid=68">Imaging</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1003"><b>Engineering & Manufacturing</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=22">CAD</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=24">EDA</a> &nbsp;<a 

href="/cgi-bin/searchbycategory.pl?cid=74">Manufacturing</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1027"><b>Security</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=85">Security</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1028"><b>Quality Assurance</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=25">Quality Certification</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=60">Web Testing</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=1020"><b>Software Engineering</b></a><br><a 

href="/cgi-bin/searchbycategory.pl?cid=25">Quality Certification</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=30">Software Maintenance</a> &nbsp;<a 

href="/cgi-bin/searchbycategory.pl?cid=71">Methodologies</a> &nbsp;<br><a 

href="/cgi-bin/searchbycategory.pl?cid=80">Software Engineering</a> &nbsp;</td></tr>
      </table>
      
      </td>
  </tr> </table> 
<table align="center">
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
        <td align="center"><font size=-2>&copy;2003 Ishtaar - All rights reserved.</font><p></p>
        </td>

  </tr>
   <tr><td><img src="/images/spacer.gif" width = "100%" height=10></td></tr>
   </table></body></html>';
print "$documentBuffer";
1;
