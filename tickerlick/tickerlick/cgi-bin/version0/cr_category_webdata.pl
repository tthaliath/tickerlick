#!usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: cr_category_webdata.pl
#Date started : 11/18/03
#Last Modified : 11/18/03
#Purpose : Create category descriptions and id hierarchically

use strict;
use DBI;  

#&getcategories('1001');

sub getcategories{
my ($catid) = $_[0];
my ($dbh,$query2,$query3,$cid1,$query1,$cid2,$cid3,$level_no1,$level_no2,$level_no3); 
my ($cat_desc1_disp,$cat_desc2_disp,$cat_desc3_disp); 
my ($cat_desc1,$cat_desc2,$cat_desc3); 

my ($sqlstr1) = "select cat_id,cat_desc,level_no,cat_desc_add from category_master_web where cat_id = ? and disp_flag = 'Y' ";
my ($sqlstr2) = "select cat_id,cat_desc,level_no,cat_desc_add from category_master_web where parent_id = ? and disp_flag = 'Y' ";

$dbh = open_dbi();
$query1= $dbh->prepare($sqlstr1) || die $query1->errstr;
$query2= $dbh->prepare($sqlstr2) || die $query2->errstr;
$query3= $dbh->prepare($sqlstr2) || die $query3->errstr;
$query1->execute($catid);
my ($i) =  0;
#print '<form name="f2" METHOD="get">
print '<table cellpadding="0" cellspacing="0" width="68%" align="center">
        <tr> 
       <td height="25" class="bluetextbold" align="left">Select Categories</td>
       </tr>
       </table>
        <table align="center" width="68%" border="1"  cellpadding="1" cellspacing="0"><tr><td>
		  <table border="0"  cellpadding="1" cellspacing="0" width="100%" align="center">';

while(($cid1,$cat_desc1_disp,$level_no1,$cat_desc1)= $query1->fetchrow_array())
{
  print '<tr><td colspan="4"><font class="categorymain">'.$cat_desc1_disp.'</font>
  &nbsp;&nbsp;<font class="categorysubbold"><a href="javascript:toggleCheck(\'f\',\'catbox\',true)">Check All</a> &nbsp;&nbsp; <a href="javascript:toggleCheck(\'f\',\'catbox\',false)">Uncheck All</a></font></td></tr>';
  if ($level_no1 == 3){next;}
  $query2->execute($cid1);
  if ($catid > 1000){
  while(($cid2,$cat_desc2_disp,$level_no2,$cat_desc2)= $query2->fetchrow_array())
    {
      print '<tr><td valign="top" colspan="4"><font class="categorysubbold">'.$cat_desc2_disp.'</font>';
      if ($level_no2 == 3){next;}
       $query3->execute($cid2);
       print '<font class="categorysub">';
       while(($cid3,$cat_desc3_disp,$level_no3,$cat_desc3)= $query3->fetchrow_array())
        {
          $cat_desc3 =~ s/\\//g;
          print '<input name="catbox" type="checkbox" value='.$cat_desc3.'>'.$cat_desc3_disp;
        }
      #print '</font><input name="catbox" type="checkbox" value='.$cat_desc2.'"'.'><font class="categorysubbold">Select All</font>';
     print '</td></tr>'; 
    }
}
else{  #cat id < 1000
    print '<tr><td valign="top" colspan="4"><font class="categorysub">';
    while(($cid2,$cat_desc2_disp,$level_no2,$cat_desc2)= $query2->fetchrow_array())
    {
      if ($level_no2 == 3){next;}
          $cat_desc2 =~ s/\\//g;
         print '<input name="catbox" type="checkbox" value='.$cat_desc2.'>'.$cat_desc2_disp;
     }
     print '</font></td></tr>';
}
}
print '<tr><td class="bluetext">Country
          </td><td class="bluetext">City/Province/Region:</td>
		  <td>&nbsp;</td>
		  <td>&nbsp;</td>
        </tr>	
          <tr> 
            
          <td valign="top">
            <select name="c2" size="4" onChange="locationDrop(this,document.f.l2)">
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
            </select></td>
			<td valign="top">
            <select name="l2" size="4" multiple>
              <option selected>----------------Select Location-----------------</option>
            </select>
              </td>
              <td valign="top" align="left"><input type="submit" name="s2" value="Search" onClick="submitForm(this);"></td>
			  <td>&nbsp;</td> 
          </tr>
		  <tr><td><img src="/images/spacer.gif" width = "100%" height=10></td></tr>';
print "</table>";
print "</td></tr></table></form>";
}

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
   my $error_message = $_[0];
   die "$error_message\n  
      ERROR: $DBI::err ($DBI::errstr)\n";
}#end: err_trap

1;




