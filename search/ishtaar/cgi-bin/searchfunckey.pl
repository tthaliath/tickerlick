#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: searchfunc.pl
#Date started : 06/18/03
#Last Modified : 11/08/03
#Purpose : Search the index data file for a given keyword(s), print the result.

use strict;
use DB_File;
use DBI;  
require "ut15_stemmer.pl";


sub prepareKeywords
{
my ($keywords) = lc shift;
my ($query_option) = shift;
my ($keypat,$keypat2,$val,$terms);
my $i = 0;
my %stop_hash;
my $catpat = 'medical transcription|medical billing|medical coding|course builder|assessment test|handheld crm|logistic crm|customer tracking system|rental crm|b2b crm|sale force automation|customer retention system|loyalty management system|oracle crm|partner relationship management|microsoft crm|enterprise application integration|web hosting|call center|telemarketing service|it help desk service|health care|health insurance|health insurance claim management|integrate health management|recruiting solution|placement management system|applicant tracking|human resource management|workforce analytic|enterprise learning solution|workflow management|precontratuaral operation|inventory management|inventory control|purchase management|import export management|part management|asset tracking|inventory tracking|insurance transcription|legal transcription|claim processing|order management|order processing|order tracking|travel reservation|central reservation|online reservation|financial service|fixed asset|loan processing|transaction processing|financial accounting|small business accounting|treasury management|cash accounting|advertisement industry|media planning|media accounting|fishery industry|material management|sale order|oracle financial|oracle application|jd edward|enterprise resource planning|sap r/3|electronic data interchange|banking system|retail banking|internet banking|asset management|asset liability management|architectural walkthrough|computer aid engineering|supply chain management|demand chain management|demand chain planning|supplier relationship management|enterprise business planning|transportation planning|electronic design automation|ic design verification|ic synthesis|static timing analysis|quality certification|cmm level|sei cmm|iso 9001|iso 9000|development model|business process outsourcing|business process management|business process reengineering|speech recognition|voice xml|internet telephony|internet voice recognition|ip pbx|computer telephony integration|human gnome project|genomic sequencing|gnome research|dna sequencing|sequence analaysis|plant disease management|gmo testing|drug discovery|software maintenance|corrective maintenance|adaptive maintenance|perfective maintenance|preventive maintenance|consultancy service|it consulting|nonpublic web site development|office automation|it service|application porting|back office automation|web design|system integration|catalog management|online store|online payment processing|business process automation|partner management|electronic commerce|retailing and distribution|global exchange|embedd system|real time application|embedd software|telecom solution|telecom billing|network management|fraud management|ip billing|explosive inventory management|explosive accounting|enterprise project|diary engineering service|enterprise wide information system|etrading infrascture|custodian system|real time order routing|retail brokerage|private trading exchange|electronic trading|trading portal|custodial data|reconciliation processing|portfolio accounting|real estate|real estate management|property management|construction management|realty office manager|project management|project monitoring|project tracking|project process maintenance|fleet management|vehicle maintenance system|dealer management|spare part management|library management|lotus note|collaborative content management|workflow automation|digital media|digital right management|media streaming|mp3 decoder|echo canceller|3d modelling|virtual realty|mobile multimedia|voice over packet|virtual private network|global positioning system|digital mapping|vehicle tracking|router management|cache system|network analyzer|network emulator|traffic management|wireless networking|wireless networking system|mobile solution|3g wireless|mobile ip|mobile computing|wireless protocol stack|wireless lan|wap browser|real time avionic|ip telephony|voice over ip|voice over wifi|document management|warehouse information management|factory management|warehouse management|air freight management system|transport information system|clearing and forwarding|multimodal shipment tracking system|electronic fulfillment system|cargo booking system|store planning system|hotel management|resort management|food and beverage management|restuarent management|hospitality management|fund management|cash management|portfolio management|online lottery|real time betting system|content management|web publishing|etl programming|content management tool customization|data migration|data cleansing|web authoring|content syndication|digital asset management|data management|document imaging|insurance solution|automobile insurance|travel insurance|fire insurance|policy administration|web testing|volume testing|regression testing|functional testing|load testing|scalable testing|business intelligence|data warehousing|data mining|statistical modeling|web mining|web analysis|video encoding|video capture|video storage and management|environment system|industrial risk analysis|water flow modeling|fluid analysis|environmental service|mobile commerce|geometric information system|automate mapping|map conversion|digital photogrammetry|hospital management|patient record management|clinical information system|occupational health|patient administration|nursing management|outpatient management|inpatient management|healthcare management|practice management|web service|\.net|photo restoration|knowledge management|design pattern|storage management|load balancing|disaster recovery|san switch|advance programming|artificial intelligence|parallel programming|weather modelling|cfd modelling|manufacturing management|industrial automation|machinery maintenance|system programming|real time operating system|kernel extension|kernel programming|real time embedd system|application suite|child care|test and measurement|fashion design|online support|online technical support|device driver|print driver|query creation|cricket information management system|software engineering|real time messaging|software inventory|fault management and analysis management|requirement management|risk and performance management|version controller|legacy system|legacy migration|legacy porting|legacy conversion|application migration|emi management|service provider management|broadband service provider management|internet service provider management|cable telephony|netegrity customization|it security|manage security service|remote firewall management|authentication system|internet advertisement|banner ad design|banner design|ad creation|it enable service|student infrastructure management|student information management|billing and payment|account receivable|account payable|general ledger|payroll processing|geographic system|photogrammetric mapping|remote sensing|aerial film scanning|wireless messaging|short messaging service|unify messaging|mobile messaging|multimedia messaging service|planning and forecasting|sale forecasting|demand planning|production planning|despatch planning|currency solution|euro solution|currency converter|conversion tool|b2b technology|wireless communication system|3g network|2\.5g network|image processing|finger print analysis|image morphing|content management technology|data warehousing & mining technology|business object|business integration technology|application servers/servlet|sun one|oracle 11i|oracle 9i|microsoft web technology|vb script|j2ee technology|other web technology|programming language|ms sql|ms access|progress server|progress rdbm|web server|microsoft iis|Web authoring tool|microsoft misual|macromedia flash|iplanet message server|operating system|window nt|free bsd|client/server tool|visual basic|sql window|ibm Platform|ibm cic|Health Care Administration|Finance, Banking & Equity|Engineering & Manufacturing|Web Design|Global Partnership|Application Software|System Software & Tool|HRM Solution|Internet Technology|Business Intelligence|Life Science|Database & Storage|Voice Technology|Content Management & Publishing|Software Engineering|Inventory & Material Management|Geographic System|Collaboration and knowledge|Hosting Service|Network Management|Digital Media|Quality Assurance';

#print "<br>$keywords\n";
my @stop_words = qw/a all & also an and are as at be been before but by can do did does each etc for from had has have he his i id if in inc into is it its limited ltd next not now of on or our per pvt she than that the their them then there thereby these they this those to ware was we were what when where which while who will with would you your/;
foreach (@stop_words) {$stop_hash{$_}++ };
map { $keypat .= ' '.stem($_) }
               grep { !( exists $stop_hash{$_} ) }
               split /[\s|\,]/, $keywords;


#if ($query_option == 3)# Exact phrase
#{
#return $keypat;
#}
#print STDERR "$keypat\n";
#print "<br>key2:$keypat\n";
my $cat_str = '';
my $keypatrest = '';
while ($keypat =~ /($catpat)/sgo){$cat_str .= $1.',';}
if ($cat_str){
  $keypat =~ s/$catpat//sgo;
  }
  $keypat =~ s/\s+/ /g;
  my $len = length($keypat);
 # print "<br>key3:$keypat:$len\n";
  $keypatrest = join(",",split (/\s/, $keypat)); 
  $keypatrest =~ s/(.*)\,$/$1/g;
  #print "<br>key4:$keypatrest\n";
  $keypat = $cat_str.$keypatrest;

return $keypat;
}

sub prepareKeywordsExact
{
my ($keyword) = lc shift;
$keyword =~ s/[\s+]/ /g;
#$keyword  =~ s/\s/(?:[ed|s|\,|\/|\\|\-|\_|\+])? /g;
return $keyword;
}

sub getresults{
my ($keystr) = $_[0];
my ($keypat) = $_[1];
my ($location) = $_[2] || 0;
my ($res_count) = $_[3];
my ($offset) = $_[4] || 0;
my ($row_count) = $_[5] || 10;
my ($sortby) = $_[6] || 'R';
my ($nolinks) = $_[7] || 5;
my ($size) = $_[8] || 'all';
my ($keycnt) = $_[9] || 0;
my ($query_option) = $_[10] || 1;

#$keypat =~ s/\s/\+/g;
my ($dbh,$site_rank,%url,$c,$page_rank,%loc_hash,$query2,$key,%hash,%cat_hash,$d,$e,$f,$query3,$val,$cid,$query1,$site_id,$parent,%site_hash);  
my ($site_loc_id,@site_arr,$site_url,$site_cat_rank,$val,$site_desc,$city,$filename,$query4,%texthash,$keytext,$pat1,$patnew,%datahash);
my ($r,$lstr,$rstr);
my $stop_words = "a all also an and are as at be been before but by can do each etc for from had has have he his how however i id if in inc into is it its limited ltd next not now of on or our per pvt she than that the their them then there thereby these they this those to ware was we were what when whenever where wherever which while who will with would you your";
my $stopwords = join("\|",split(/\s/,$stop_words));
#print "<br>size:$size<br>\n";
$dbh = open_dbi();
my ($sqlstr1);
if ($sortby eq 'L'){ #Sort by location

if ($query_option == 2) #Any of the keywords
{
if ($size eq "all"){ #any size
if ($location == 0){ # all locations
$sqlstr1 = "select count(site_id) a,sum(site_key_rank) b, site_id from site_key_rank
where keyword in (".$keystr.") group by site_id order by city, a desc,b desc limit ".$offset.",".$row_count;
}
else { #location
$sqlstr1 = "select count(site_id) a,sum(site_key_rank) b, site_id from site_key_rank 
where keyword in (".$keystr.") and site_loc_id in (".$location.") group by site_id 
order by city, a desc,b desc limit ".$offset.",".$row_count;
}
}
else { #size matters
if ($location == 0){ # all locations
$sqlstr1 = "select count(site_id) a,sum(site_key_rank) b, site_id from site_key_rank
where keyword in (".$keystr.") and site_size = ".$size." group by site_id order by city, a desc,b desc limit ".$offset.",".$row_count;
}
else{#location
$sqlstr1 = "select count(site_id) a,sum(site_key_rank) b, site_id from site_key_rank
where keyword in (".$keystr.") and site_loc_id in (".$location.") and site_size = ".$size." group by site_id
order by city, a desc,b desc limit ".$offset.",".$row_count;
}
}
}
else { # All of the keywords
if ($size eq "all"){ #any size
if ($location == 0){ # all locations
$sqlstr1 = "select count(site_id) a,sum(site_key_rank) b, site_id from site_key_rank
where keyword in (".$keystr.") group by site_id having count(site_id) = ".$keycnt." order by city, b desc limit ".$offset.",".$row_count;
}
else {# location
 $sqlstr1 = "select count(site_id) a,sum(site_key_rank) b, site_id from site_key_rank 
where keyword in (".$keystr.") and site_loc_id in (".$location.") group by site_id 
having count(site_id) = ".$keycnt." order by city, b desc limit ".$offset.",".$row_count;
}
}
else { #size matters
if ($location == 0){ # all locations
$sqlstr1 = "select count(site_id) a,sum(site_key_rank) b, site_id from site_key_rank
where keyword in (".$keystr.") and site_size = ".$size." group by site_id  
having count(site_id) = ".$keycnt." order by city, b desc limit ".$offset.",".$row_count;
}
else{ #location
$sqlstr1 = "select count(site_id) a,sum(site_key_rank) b, site_id from site_key_rank
where keyword in (".$keystr.") and site_loc_id in (".$location.") and site_size = ".$size." group by site_id
having count(site_id) = ".$keycnt." order by city, b desc limit ".$offset.",".$row_count;
}
}
}
}
else  #sort by relevance
{
if ($query_option == 2) #Any of the keywords
{
if ($size eq "all"){ #any size
if ($location == 0){ # all locations
$sqlstr1 = "select count(site_id) a,sum(site_key_rank) b, site_id from site_key_rank
where keyword  in (".$keystr.") group by site_id order by a desc,b desc limit ".$offset.",".$row_count;
}
else {#location
  $sqlstr1 = "select count(site_id) a,sum(site_key_rank) b, site_id from site_key_rank 
where keyword  in (".$keystr.") and site_loc_id in (".$location.") group by site_id 
order by a desc,b desc limit ".$offset.",".$row_count;
}
}
else { #size matters
if ($location == 0){ # all locations
$sqlstr1 = "select count(site_id) a,sum(site_key_rank) b, site_id from site_key_rank
where keyword  in (".$keystr.") and site_size = ".$size." group by site_id order by a desc,b desc limit ".$offset.",".$row_count;
}
else{#location
$sqlstr1 = "select count(site_id) a,sum(site_key_rank) b, site_id from site_key_rank
where keyword  in (".$keystr.") and site_loc_id in (".$location.") and site_size = ".$size." group by site_id order by a desc,b desc limit ".$offset.",".$row_count;
}
}
}
else # All of the keywords
{
if ($size eq "all"){ #any size
if ($location == 0){ # all locations
$sqlstr1 = "select count(site_id) a,sum(site_key_rank) b, site_id from site_key_rank
where keyword in (".$keystr.") group by site_id
having count(site_id) = ".$keycnt." order by b desc limit ".$offset.",".$row_count;
}
else {#location
 $sqlstr1 = "select count(site_id) a,sum(site_key_rank) b, site_id from site_key_rank 
where keyword in (".$keystr.") and site_loc_id in (".$location.") group by site_id 
having count(site_id) = ".$keycnt." order by b desc limit ".$offset.",".$row_count; 
}
}
else { #size matters
if ($location == 0){ # all locations
$sqlstr1 = "select count(site_id) a,sum(site_key_rank) b, site_id from site_key_rank
where keyword in (".$keystr.") and site_size = ".$size." group by site_id having count(site_id) = ".$keycnt." order by b desc limit ".$offset.",".$row_count;
}
else {#location
$sqlstr1 = "select count(site_id) a,sum(site_key_rank) b, site_id from site_key_rank
where keyword in (".$keystr.") and site_loc_id in (".$location.") and site_size = ".$size." group by site_id having count(site_id) = ".$keycnt." order by b desc limit ".$offset.",".$row_count;
}
}
}
}
#print "<br>tom2:$sqlstr1\n";
$query4= $dbh->prepare($sqlstr1) || die $query4->errstr;;
$query4->execute();
my ($sitelist) = '';
while(($c,$d,$site_id)= $query4->fetchrow_array())
{
  
  push (@site_arr,$site_id);
  $sitelist .= '"'.$site_id.'",'
}

$sitelist =~ s/(.*)\,/\1/g;
#print "<tr><td>$sitelist</td></tr>";
my ($sqlstr);
if ($location == 0){ # all locations
$sqlstr = "select site_id,link_str from site_key_rank where keyword in (".$keystr.") and site_id in (".$sitelist.")";
}
else{ #location
$sqlstr = "select site_id,link_str from site_key_rank where keyword in (".$keystr.") and site_loc_id in (".$location.") and site_id in (".$sitelist.")";
}
#print "<tr><td>$sqlstr</td></tr>";

my $linkfilename = 'valid_links_dbfile.txt';
tie (%hash, 'DB_File', $linkfilename, O_RDWR, 0444, $DB_BTREE) || die $!;

my $linktextfilename = 'link_key_text_dbfile.txt';
tie (%texthash, 'DB_File', $linktextfilename, O_RDWR, 0444, $DB_BTREE) || die $!;

my $linkdatafilename = 'link_data_dbfile.txt';
tie (%datahash, 'DB_File', $linkdatafilename, O_RDWR, 0444, $DB_BTREE) || die $!;

$query3= $dbh->prepare ('select site_id,site_url,site_desc,location,filename from site_master ') || die $query3->errstr;
$query3->execute();
while(($site_id,$site_url,$site_desc,$city,$filename)= $query3->fetchrow_array())
{
    
   $city = ucfirst($city);
   #$loc_hash{$site_id} = $site_loc_id;
   $url{$site_id} = "$site_url\t$site_desc\t$city\t$filename";
}

$query3->finish;



my ($i) = 0;
my ($j) = 0;
my (%link_str_hash,$link_str);
$query2 = $dbh->prepare ($sqlstr) || die $query2->errstr;
print "<br>tomerr:$sqlstr\n";
$query2->execute();
my ($link,%link_hash,$page_title,$page_link);
while(($site_id,$link_str)= $query2->fetchrow_array())
{
   $j++;

  foreach $link(split (/\,/,$link_str))
  {
    $link_str_hash{$site_id}{$link}++;
  }
     
}

$query2->finish;

my ($k,$upperlimit,$pat);
my ($filename) = '';
#dIsplay total results
if ($res_count > ($offset+$row_count)) 
{
  $upperlimit = $offset+$row_count;
}
else{$upperlimit = $res_count;}
print '<tr><td><TABLE width="100%" align="left">
  <COLGROUP>
  <COLGROUP>
  <COLGROUP>

    <TR>
	  
      <TH width="70%" SCOPE=col>&nbsp;</TH>
      <TH width="15%" SCOPE=col>&nbsp;</TH>
      <TH width="15%" SCOPE=col>&nbsp;</TH>
	 
    </TR>

  <TBODY>
    <TR bgcolor="">
            <TD SCOPE=row valign="top">';

print "<table><tr><td colspan=2><SPAN class='bluekeytextbold'>Web Results ".($offset+1)."-".$upperlimit." of ".$res_count."</span><br><br></td></tr>"; 
#print "<br>option:$query_option\n";
foreach $key (@site_arr)
{



 if ($url{$key} =~ /(.*?)\t(.*?)\t(.*?)\t(.*)/){
  #print "<br>$1&nbsp;$2&nbsp;$3\n";
  print '<tr>
  <td width="40%" valign="top" colspan=1><a href='."http://".$1.'><span class="bluekeytext">'.$2.'</span></a>&nbsp;&nbsp;'.$3;
  $filename = $4;
  }
 %link_hash = %{ $link_str_hash{$key} };
$k = 0;
if ($query_option == 2){ # All of the keywords
foreach $link( sort { $link_hash{$b} <=> $link_hash{$a} } keys (%link_hash))
 {
    #print "<br>$link_hash{$link}\n";
    ($page_link,$page_title) = split (/\t/,$hash{$link});
    $k++;
    if ($k <= $nolinks){
    $filename =~ s/\s+//g;
    #print "<br>$keypat\n";
    $keytext = '';
     $patnew = '';
     $pat1 = '';
     $keypat =~ s/\+/ /g;
    foreach $pat(split(/\|/,$keypat)){
     $keytext .= $texthash{$link."-".$pat};
    # if ($pat =~ /\+/){$pat =~ s/\+/\\\+/g;}
     if ($pat =~ /(y)$/){$patnew = $pat;$patnew = $pat."|".$`."ies"."|".$`."ied";}
     elsif ($pat=~ /\s/){$patnew = $pat;$patnew =~ s/\s/(?:ed|s|)?(?: )?(?:$stopwords)? /g;}
     else {$patnew = $pat;}
     $pat1 .= $patnew."|";
     }
     $pat1 =~ s/(.*)\|$/\1/g;
     $keytext =~ s/\.\.\.+/\.\.\./g;
     #print "<br>$pat1\n";
     $keytext =~ s/\b($pat1)\b/<b>\1<\/b>/gi;
    $keypat =~ s/\s/\+/g;
     if (length($page_title) > 60)
     {
        $page_title = substr($page_title,0,index($page_title," ",60));
        #$page_title =~ s/(.*){60}(.*?)\s/\1\2/;
        #$page_title =~ s/(.*)\s+$/\1/g;
     }
     #print "<br>$datahash{$link}\n";
     if ($datahash{$link} =~ /($pat1)/i){
       $r = reverse($`);
       $lstr = substr($r,0,index($r," ",100));
       $lstr = reverse($lstr);
       $rstr = substr($',0,index($'," ",100));
       #print "<br>$lstr$1$rstr\n\n";
     }
     print "<br><class=\"linktextsize\">$keytext</class><br><a href=$hash{$link}><span class=\"bluekeytextsmall\">$page_title</span></a>&nbsp;&nbsp;<a href=/cgi-bin/snapshot.pl?fn=$filename&linkid=$link&terms=$keypat&cat=0><span class=\"bluekeytextsmall\">Cached</span></a>";
    }
    else {last;}
 }
} 
else{  #Any keyword

foreach $link( sort  {sortlinkbykeyword1($link_hash{$b}) <=> sortlinkbykeyword2($link_hash{$a}) ||  $link_hash{$b} <=> $link_hash{$a} } keys (%link_hash))
 {
   #print "<br>$link_hash{$link}\n";
    ($page_link,$page_title) = split (/\t/,$hash{$link});
    $k++;
    if ($k <= $nolinks){
    $filename =~ s/\s+//g;
    $keytext = '';
    $patnew = '';
     $pat1 = '';
    $keypat =~ s/\+/ /g;
    foreach $pat(split(/\|/,$keypat)){
     $keytext .= $texthash{$link."-".$pat};
     #if ($pat =~ /\+/){$pat =~ s/\+/\\\+/g;}
     if ($pat =~ /(y)$/){$patnew = $pat;$patnew = $pat."|".$`."ies"."|".$`."ied";}
     elsif ($pat=~ /\s/){$patnew = $pat;$patnew =~ s/\s/(?:ed|s|)?(?: )?(?:$stopwords)? /g;}
     else {$patnew = $pat;}
     $pat1 .= $patnew."|";
     }
    $pat1 =~ s/(.*)\|$/\1/g;
    #print "<br>$pat1\n";
    $keytext =~ s/\.\.\.+/\.\.\./g;
    $keytext =~ s/\b($pat1)\b/<b>\1<\/b>/gi;
    $keypat =~ s/\s/\+/g;
    if (length($page_title) > 60)
     {
         $page_title = substr($page_title,0,index($page_title," ",60));
         #$page_title =~ s/(.*){60}(.*?)\s/\1\2/;
       # $page_title =~ s/(.*)\s+$/\1/g;
     }
    # print "<br>$datahash{$link}\n";
      if ($datahash{$link} =~ /($pat1)/i){
      $r = reverse($`);
       $lstr = substr($r,0,index($r," ",100));
       $lstr = reverse($lstr);
       $rstr = substr($',0,index($'," ",100));
       #print "<br>$lstr$1$rstr\n\n";
      }
     print "<br><class=\"linktextsize\">$keytext</class><br><a href=$hash{$link}><span class=\"bluekeytextsmall\">$page_title</span></a>&nbsp;&nbsp;<a href=/cgi-bin/snapshot.pl?fn=$filename&linkid=$link&terms=$keypat&cat=0><span class=\"bluekeytextsmall\">Cached</span></a>";
    }
    else {last;}
 }
}
print "<br>&nbsp;\n";
}
print "</td></tr></table>\n";

print '</TD><TD>&nbsp;</TD><TD valign="top">';
#Print links to results page
my ($res_limit) = 0;
my ($j) = 0;
my ($new_offset) = 0;
my ($next_offset,$prev_offset);
if ($res_count > $row_count)
{
  print '<table width=100% cellpadding=0 cellspacing=0 border=0 >
<tr><td rowspan=5>&nbsp;&nbsp;</td><td width=1 bgcolor=#c9d7f1 rowspan=5><img width=1 height=1 alt=""></td><td rowspan=5>&nbsp;&nbsp;</td>
<td rowspan="5" bgcolor=#c9d7f1>Sponsored Links</td></tr></table>
</TD></TR><tr><td colspan="3"><table align="center" ><tr><td><b>Results Page:<b></td>';
if ($offset > 0)
{
  $prev_offset = $offset - $row_count;
  print "<td><a href=/cgi-bin/searchkey.pl?fr=$prev_offset&catid=$keystr&catstr=$keypat&lid=$location&rc=$row_count&rt=$res_count&pt=RESULT&cs=$size&nl=$nolinks&kc=$keycnt&so=$sortby>Previous</a></td>"; 
 print "<td><a href=/cgi-bin/searchkey.pl?fr=$prev_offset&catid=$keystr&catstr=$keypat&lid=$location&rc=$row_count&rt=$res_count&pt=RESULT&cs=$size&nl=$nolinks&kc=$keycnt&so=$sortby><img src='/images/ar_prev.gif' border=0 alt='Previous'></a></td>";
}
while($res_limit <= $res_count)
{
 $j++; 
 if ($offset == $res_limit) { # Current page
  print "<td>$j</td>";
  $next_offset = $offset + $row_count; 
 }
 else
  {
   $keystr =~ s/\s/\+/g;
   $keypat =~ s/\s/\+/g; 
    print "<td><a href=/cgi-bin/searchkey.pl?fr=$new_offset&catid=$keystr&catstr=$keypat&lid=$location&rc=$row_count&rt=$res_count&pt=RESULT&cs=$size&nl=$nolinks&kc=$keycnt&so=$sortby>$j</a></td>\n";
    } 
  $res_limit += $row_count;
  $new_offset += $row_count;
}
if ($next_offset < $res_count){
#PRINT next

print "<td><a href=/cgi-bin/searchkey.pl?fr=$next_offset&catid=$keystr&catstr=$keypat&lid=$location&rc=$row_count&rt=$res_count&pt=RESULT&cs=$size&nl=$nolinks&kc=$keycnt&so=$sortby><img src='/images/ar_next.gif' border=0 alt='Next'></a></td>";
print "<td><a href=/cgi-bin/searchkey.pl?fr=$next_offset&catid=$keystr&catstr=$keypat&lid=$location&rc=$row_count&rt=$res_count&pt=RESULT&cs=$size&nl=$nolinks&kc=$keycnt&so=$sortby>Next</a></td>";
}
print "</tr></table></td></tr>";
}
else {print '&nbsp;</TD></TR>';}
#$dbh->commit;
$dbh->disconnect();
untie %hash;
untie %texthash;
untie %datahash;

}

sub checkresults{
my ($keyref) = $_[0];
my ($location) = $_[1] || 0;
my ($offset) = $_[2] || 0;
my ($row_count) = $_[3] || 10;
my ($query_option) = $_[4] || 2;
my ($sortby) = $_[5] || 'R';
my ($nolinks) = $_[6] || 5;
my ($size) = $_[7] || 'all';
my ($exactkeypat) = $_[8]; # only for exact phrase;

my ($keystr,$query4,$dbh,%datahash,$val,$val1,%cat_hash,$keypat,$res_count,$keycnt,$site_id,$site_cnt);
$keycnt = 0;
$keyref =~ s/^,//;
$keyref =~ s/\,\,/\,/g;
foreach $val(split (/\,/,$keyref)){
#print "<br>val:$val\n"; 
$keystr .= '"'.$val.'",';
$keypat .= $val.'|';
$keycnt++;
}

$keystr =~ s/(.*)\,$/\1/g;
$keypat =~ s/(.*)\|$/\1/g;

# Get the no of results using criteria
$dbh = open_dbi();

my ($sqlstr);
if ($query_option == 2){ #Any of the keywords
if ($size eq "all"){ #any size
if ($location == 0){ # all locations
$sqlstr = "select count(distinct site_id) from site_key_rank where
keyword in (".$keystr.")";
}
else #location
{
$sqlstr = "select count(distinct site_id) from site_key_rank where 
keyword in (".$keystr.") and site_loc_id in (".$location.")";
}
}
else{ #size matters
$size = '"'.$size.'"';
if ($location == 0){ # all locations
$sqlstr = "select count(distinct site_id) from site_key_rank where
keyword in (".$keystr.") and site_size = ".$size;
}
else { #location
$sqlstr = "select count(distinct site_id) from site_key_rank where
keyword in (".$keystr.") and site_loc_id in (".$location.") and 
site_size = ".$size;
}
}

print "<br>tom1:$sqlstr\n";

$query4= $dbh->prepare($sqlstr) || die $query4->errstr;
$query4->execute();
($res_count) = $query4->fetchrow_array();
}
elsif ($query_option == 1 ) # All of the keywords
{
if ($size eq "all"){ #any size 
if ($location == 0){ # all locations
 $sqlstr = "select count(site_id),site_id from site_key_rank where
keyword in (".$keystr.") group by site_id
having count(site_id) = ".$keycnt;
}
else { #location
  $sqlstr = "select count(site_id),site_id from site_key_rank where 
keyword in (".$keystr.") and site_loc_id in (".$location.") group by site_id 
having count(site_id) = ".$keycnt;
}
}
else { #size matters
$size = '"'.$size.'"';
if ($location == 0){ # all locations
$sqlstr = "select count(site_id),site_id from site_key_rank where
keyword in (".$keystr.") and
site_size = ".$size." group by site_id having count(site_id) = ".$keycnt;
}
else { #location
$sqlstr = "select count(site_id),site_id from site_key_rank where
keyword in (".$keystr.") and site_loc_id in (".$location.") and 
site_size = ".$size." group by site_id having count(site_id) = ".$keycnt;
}
}
print "<br>tom2:$sqlstr\n";
$query4= $dbh->prepare($sqlstr) || die $query4->errstr;
$query4->execute();
$res_count = 0;
while (($site_cnt,$site_id) = $query4->fetchrow_array())
{
  $res_count++;
}
}
else { # exact phrase
#print "<br>exact1 keystr:$keystr\n";
if ($size eq "all"){ #any size
if ($location == 0){ # all locations
 $sqlstr = "select count(link_id),link_id from link_key where
keyword in (".$keystr.") group by link_id having count(link_id) = ".$keycnt;
}
else { #location
$sqlstr = "select count(link_id),link_id from link_key where loc_id in (".$location.") and keyword in (".$keystr.") group by link_id
having count(link_id) = ".$keycnt;
}
}
else { #size matters
$size = '"'.$size.'"';
if ($location == 0){ # all locations
$sqlstr = "select count(link_id),link_id from link_key where
keyword in (".$keystr.") and site_size = ".$size." group by link_id having count(link_id) = ".$keycnt; 
}
else { #location
$sqlstr = "select count(link_id),link_id from link_key where loc_id in (".$location.") and keyword in (".$keystr.") and site_size = ".$size." group by link_id having count(link_id) = ".$keycnt;
}
}
print "<br>tom2:$sqlstr\n";
$query4= $dbh->prepare($sqlstr) || die $query4->errstr;
$query4->execute();
$res_count = 0;
my ($link_cnt,$link_id,$pat,$pat1,$patnew,%site_hash,$cid,$str);
my $linkdatafilename = 'link_data_dbfile.txt';
tie (%datahash, 'DB_File', $linkdatafilename, O_RDWR, 0444, $DB_BTREE) || die $!;
 print "<br>$exactkeypat<br>$keystr\n";
# $exactkeypat = "Java and EJB components";
while (($link_cnt,$link_id) = $query4->fetchrow_array())
{
  #last;
  #print "<br>$link_id\n";
  if ($datahash{$link_id} =~ /$exactkeypat/oi){ 
  $str= $datahash{$link_id};  
  $str =~ s/($exactkeypat)/<font color=red>\1<\/font>/gi;
  print "<br>$str\n\n"; 
  ($cid) = split (/-/,$link_id);
  if (!$site_hash{$cid}){ 
  $res_count++;
  $site_hash{$cid}++;
  }
 }
}
} 
untie %datahash;
if ($res_count == 0) {return;}
$res_count = 100 unless $res_count < 100;

&getresults($keystr,$keypat,$location,$res_count,$offset,$row_count,$sortby,$nolinks,$size,$keycnt,$query_option);

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
   my $error_message = shift(@_);
   die "$error_message\n  
      ERROR: $DBI::err ($DBI::errstr)\n";
}#end: err_trap

sub sortlinkbykeyword1{
my $link = shift;
if ($link =~ /product|service|solution|expert|industr/i)
{
  return 1;
}
else {return 0;}
}

sub sortlinkbykeyword2{
my $link = shift;
if ($link =~ /product|service|solution|expert|industr/i)
{
  return 1;
}
else {return 0;}
}

1;




