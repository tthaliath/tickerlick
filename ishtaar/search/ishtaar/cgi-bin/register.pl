#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: register.cgi
#Date started : 09/14/04
#Last Modified : 09/14/04
#Purpose : Register a firm
use strict;
use CGI;
use DBI;
require "pagecommon.pl";
my ($dbh,$query,$domain_name,$site_id,$site_desc,$site_url,$loc_id1,$cloc1,$country_name,$cloc2,$cemail,$contacturl,$cphone);
my ($q) = new CGI;
my ($title,%req_fields,$url,$domain,$firm,$orig_url,$country_code);
%req_fields = {cname => 1,
               ccountry => 1,
               curl => 1,
               ccountry => 1,
               cloc1 => 1,
               cemail => 1
               }; 
print "Content-type:text/html\n\n";
$| = 1;
#get all the form variable values
my ($url) = $q->param("check_url");
my ($action) = $q->param("action");
$action = "Check";
if ($action eq "Check"){

$orig_url = $url;
$url=~s#^http://##gi;               # strip off http://
$url=~s/(.*)#.*/$1/;
($domain=$url)=~s#^([^/]+).*#$1#;   # everything before first / is domain
$url =~ /.*?\.(.*?)\.(.*)/;
$domain_name = lc $1;
$domain_name = "infosysco";
$dbh = open_dbi();
$query = $dbh->prepare ( 'select a.site_id,a.site_url,a.site_desc,a.loc_id1,b.city,b.country_name from company_contact_master a, location_master b where domain_name = ?  and a.loc_id1 = b.city_id ')|| die $query->errstr;
$query->execute($domain_name);
while(($site_id,$site_url,$site_desc,$loc_id1,$cloc1,$country_name)= $query->fetchrow_array())
{
last;
}
if ($site_id) {#site exists
print &page_header('Update Your Company Profile');
print &page_top();
print '<form name="register" action="/cgi-bin/register.cgi">
<input type="hidden" name="action" value="update">
<table align="center" cellspacing=0 cellpadding=0 border=1 width="60%"><tr>
      <td> <table align="center" cellspacing=0 cellpadding=0 border=0 width="95%">
          <tr> 
            <td colspan="2"><b><font class="desctextred">Congratulations!!!</font>&nbsp;&nbsp;&nbsp; 
              &nbsp;<font class="desctext">ISHTAAR has already added your firm 
              in the search database. In order to better serve you, Please verify/update 
              the information about your firm. The red color labels are required fields.</font></b> </td>
          </tr>
          <tr> 
            <td colspan="2"><img src="/images/spacer.gif" width = "100%" height=20></td>
          </tr>
          <tr> 
            <td><font class="desctextred">Name:</font></td>
            <td><input type="text" name="cname" size="35" maxlength="255" value='.$site_desc.'></td>
          </tr>
          <tr> 
            <td colspan="2"><img src="/images/spacer.gif" width = "100%" height=10></td>
          </tr>
		  <tr> 
            <td><font class="desctextred">Home Page:</font></td>
            <td><input type="text" name="curl" size="50" maxlength="255" value='.$site_url.'></td>
          </tr>
		  <tr> 
            <td colspan="2"><img src="/images/spacer.gif" width = "100%" height=10></td>
          </tr>
          <tr> 
            <td colspan="2">Location: Please enter a maximum of two locations 
              where your comopany have Production/ Design/ Development facilities.</td>
          </tr>
          <tr> 
            <td colspan="2"><img src="/images/spacer.gif" width = "100%" height=10></td>
          </tr>
          <tr>
            <td colspan="2" valign="top"><font class="desctextred">Country:'.$country_name.'</font></td>
            </tr>
			 <tr> 
            <td colspan="2"><img src="/images/spacer.gif" width = "100%" height=10></td>
             </tr>
            <tr> 
            <td><font class="desctextred">Location 1:</font>&nbsp;&nbsp;<input type="text" name="cloc1" value='.$cloc1.'></td>
			<td>Location 2:&nbsp;&nbsp; 
              <input type="text" name="cloc2" value='.$cloc2.'></td>
          </tr>
		  <tr> 
            <td colspan="2"><img src="/images/spacer.gif" width = "100%" height=10></td>
             </tr>
			 <tr> 
            <td colspan="2"><b><font class="desctextred">Contact Information:</font></td>
             </tr>
			 <tr> 
            <td><font class="desctextred">Email:</font>&nbsp;&nbsp;<input type="text" name="cemail" value='.$cemail.'></td>
			<td>Telephone:&nbsp;&nbsp;<input type="text" name="cphone" value='.$cphone.'></td>
          </tr>
		  <tr> 
            <td colspan="2">Contact Page URL:&nbsp;&nbsp;<input type="text" name="contacturl" width="300" value='.$contacturl.'></td>
          <tr> 
            <td colspan="2"><img src="/images/spacer.gif" width = "100%" height=10></td>
             </tr>
		 
		  <tr><td colspan="2" align="center"><input type="submit"  value="Update" onClick="submitForm(this);"></td>
          </tr>
		  <tr> 
            <td><img src="/images/spacer.gif" width = "100%" height=5></td>
          </tr>
        </table></td>
    </tr></table>
</form>';

} #site exists
else{
print &page_header('Submit Your Company Profile');
print &page_top();
print '<form name="register" action="/cgi-bin/register.cgi">
<input type="hidden" name="action" value="update">
<table align="center" cellspacing=0 cellpadding=0 border=1 width="60%"><tr>
      <td> <table align="center" cellspacing=0 cellpadding=0 border=0 width="95%">
          <tr> 
            <td colspan="2"><b><font class="desctextred"> 
              <font class="desctext">Your company is not 
              in our search database. In order to add your firm to our search database, please fill the following form and submit.
              The red color labels are required fields.</font></b> </td>
          </tr>
          <tr> 
            <td colspan="2"><img src="/images/spacer.gif" width = "100%" height=20></td>
          </tr>
          <tr> 
            <td><font class="desctextred">Name:</font></td>
            <td><input type="text" name="cname" size="35" maxlength="255" value='.$site_desc.'></td>
          </tr>
          <tr> 
            <td colspan="2"><img src="/images/spacer.gif" width = "100%" height=10></td>
          </tr>
		  <tr> 
            <td><font class="desctextred">Home Page:</font></td>
            <td><input type="text" name="curl" size="50" maxlength="255" value='.$site_url.'></td>
          </tr>
		  <tr> 
            <td colspan="2"><img src="/images/spacer.gif" width = "100%" height=10></td>
          </tr>
          <tr> 
            <td colspan="2">Location: Please enter a maximum of two locations 
              where your comopany have Production/ Design/ Development facilities.</td>
          </tr>
          <tr> 
            <td colspan="2"><img src="/images/spacer.gif" width = "100%" height=10></td>
          </tr>
          <tr>
            <td valign="top"><font class="desctextred">Country:'.$country_name.'</font></td>
			<td valign="top">
                <select name="ccountry">
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
            </tr>
			 <tr> 
            <td colspan="2"><img src="/images/spacer.gif" width = "100%" height=10></td>
             </tr>
            <tr> 
            <td><font class="desctextred">Location 1:</font>&nbsp;&nbsp;<input type="text" name="cloc1" value=""></td>
			<td>Location 2:&nbsp;&nbsp; 
              <input type="text" name="cloc2" value=""></td>
          </tr>
		  <tr> 
            <td colspan="2"><img src="/images/spacer.gif" width = "100%" height=10></td>
             </tr>
			 <tr> 
            <td colspan="2"><b><font class="desctextred">Contact Information:</font></td>
             </tr>
			 <tr> 
            <td><font class="desctextred">Email:</font>&nbsp;&nbsp;<input type="text" name="cemail" value=""></td>
			<td>Telephone:&nbsp;&nbsp;<input type="text" name="cphone" value=""></td>
          </tr>
		  <tr> 
            <td colspan="2">Contact Page URL:&nbsp;&nbsp;<input type="text" name="contacturl" value="" width="300"></td>
          <tr> 
            <td colspan="2"><img src="/images/spacer.gif" width = "100%" height=10></td>
             </tr>
		 
		  <tr><td colspan="2" align="center"><input type="submit"  value="Submit" onClick="submitForm(this);"></td>
          </tr>
		  <tr> 
            <td><img src="/images/spacer.gif" width = "100%" height=5></td>
          </tr>
        </table></td>
</tr></table>
    </form>';
} #Company is new
} #check
print "</td></tr></table>\n";

print &page_footer;

sub open_dbi
{
   # Declare and initialize variables
   my $host = 'localhost';
   my $db = 'ishtaar';
   my $db_user = 'istrtest';
   my $db_password = 'istrtest';

   # Connect to the requested server

   my $dbh = DBI->connect("dbi:mysql:$db:$host", "$db_user", "$db_password")
      or err_trap("Cannot connect to the database");
   return $dbh;
}#end: open_dbi

#==================== [ err_trap ] ====================
sub err_trap
{
   my $error_message = shift(@_);
   die "$error_message\n
      ERROR: $DBI::err ($DBI::errstr)\n";
}#end: err_trap

1;
