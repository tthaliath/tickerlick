#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: searchfunc.pl
#Date started : 06/18/03
#Last Modified : 11/08/03
#Purpose : Search the index data file for a given keyword(s), print the result.

use strict;
use DB_File;
use DBI;  

sub prepareKeywords
{
my ($keywords) = lc shift;
my ($keypat1) = shift;
my $remove_pat = 'a|all|also|an|and|are|as|at|be|been|before|but|by|can|do|each|etc|for|from|had|has|have|he|his|i|id|if|in|inc|into|is|it|its|limited|ltd|next|not|now|of|on|or|our|per|pvt|she|than|that|the|their|them|then|there|thereby|these|they|this|those|to|ware|was|we|were|what|when|where|which|while|who|will|with|would|you|your';
#$keywords =~ s/\b$remove_pat\b/ /g;
#$keywords =~ s/\s+/ /g;
my ($keypat,$keypat2,$val,$terms);
my $i = 0;
my %stop_hash;
#$keypat = $keywords;
my @stop_words = qw/a all also an and are as at be been before but by can do each etc for from had has have he his i id if in inc into is it its limited ltd next not now of on or our per pvt she than that the their them then there thereby these they this those to ware was we were what when where which while who will with would you your/;
foreach (@stop_words) {$stop_hash{$_}++ };
map { $keypat .= ' '.$_ }
               grep { !( exists $stop_hash{$_} ) }
               split /\s+/, $keywords;


my %key_hash;
my $keyfile = "category_text_dbfile.txt";
tie (%key_hash, 'DB_File', $keyfile, O_RDWR, 0444, $DB_BTREE) || die $!;
#$keypat1 = '';
#print "<tr><td>$keypat</td></tr>";
$terms = $key_hash{'1'};
#$terms = 'fault management and analysis management|content management tool customization|cricket information management system|broadband service provider management|internet service provider management|multimodal shipment tracking system|enterprise wide information system|enterprise application integration|health insurance claim management|student infrastructure management|collaborative content management|warehouse information management|supplier relationship management|partner relationship management|risk and performance management|explosives inventory management|student information management|nonpublic web site development|computer telephony integration|business process reengineering|enterprise learning solutions|electronic fulfillment system|air freight management system|transport information system|geometric information system|enterprise resource planning|food and beverage management|electronic design automation|business process outsourcing|video storage and management|enterprise business planning|multimedia messaging service|integrated health management|project process maintenance|clinical information system|business process management|electronic data interchange|business process automation|placement management system|precontratuaral operations|wireless networking system|imports exports management|remote firewall management|internet voice recognition|computer aided engineering|real time embedded systems|asset liability management|diary engineering services|real time operating system|retailing and distribution|vehicle maintenance system|loyalty management system|human resource management|small business accounting|architectural walkthrough|digital rights management|reconciliation processing|customer retention system|global positioning system|online payment processing|managed security services|patient record management|real time betting system|online technical support|industrial risk analysis|manufacturing management|private trading exchange|wireless protocol stacks|customer tracking system|digital asset management|plant disease management|photogrammetric mapping|netegrity customization|real time order routing|transportation planning|supply chain management|artificial intelligence|short messaging service|requirements management|virtual private network|insurance transcription|clearing and forwarding|demand chain management|sales force automation|patient administration|hospitality management|ic design verification|real time applications|perfective maintenance|environmental services|costruction management|corrective maintenance|static timing analysis|digital photogrammetry|preventive maintenance|real estate management|telemarketing services|back office automation|spare parts management|transaction processing|machinery maintenance|healthcare management|industrial automation|realty office manager|business intelligence|outpatient management|it help desk services|demand chain planning|policy administration|fianancial accounting|medical transcription|store planning system|restuarent management|authentication system|finger print analysis|application migration|explosives accounting|inventory management|statistical modeling|aerial film scanning|recruiting solutions|knowledge management|parallel programming|etrading infrascture|portfolio management|software maintenance|xsl/css presentation|portfolio accounting|materials management|inpatient management|test and measurement|warehouse management|cargo booking system|automobile insurance|practice management |adaptive maintenance|central reservation|insurance solutions|inventory tracking |workflow automation|real time messaging|legal transcription|document management|water flow modeling|property management|content syndication|occupational health|billing and payment|material management|production planning|workflow management|workforce analytics|human gnome project|electronic commerce|xml data processing|accounts receivable|it enabled services|hospital management|purchase management|application porting|treasury management|systems integration|sequence analaysis|electronic trading|payroll processing|oracle application|catalog management|internet telephony|businesstocustomer|travel reservation|nursing management|online reservation|partner management|applicant tracking|content management|storage management|regression testing|functional testing|version controller|speech recognition|network management|real time avionics|project monitoring|currency converter|financial services|library management|software inventory|traffic management|kernel programming|genomic sequencing|factory management|weather modelling|automated mapping|photo restoration|kernel extensions|mobile multimedia|inventory control|unified messaging|legacy conversion|resort management|dealer management|sales forecasting|router management|custodian systems|embedded software|business2customer|claims processing|voice over packet|disaster recovery|despatch planning|office automation|vehicle tracking|data warehousing|order management|order processing|mobile computing|mobile solutions|network analyzer|hotel management|asset management|fleet management|oracle financial|retail brokerage|network emulator|asic/fpga design|internet banking|legacy migration|accounts payable|embedded systems|banner ad design|mobile messaging|project tracking|scalable testing|image processing|fraud management|parts management|health insurance|media accounting|business objects|document imaging|travel insurance|cash accounting|demand planning|mobile commerce|assessment test|medical billing|data management|media streaming|conversion tool|loan processing|digital mapping|embedded system|global exchange|etl programming|ippbx migration|cable telephony|voice over wifi|fund management|cash management|telecom billing|fashion design|data cleansing|general ledger|euro solutions|dna sequencing|data migration|retail banking|load balancing|course builder|banking system|volume testing|virtual realty|transportation|video encoding|media planning|medical coding|image morphing|map conversion|online lottery|remote sensing|photogrammetry|microstrategy |gnome research|trading portal|asset tracking|echo canceller|custodial data|drug discovery|query creation|legacy porting|device drivers|emi management|fire insurance|fluid analysis|order tracking|web publishing|banner design|logistics crm|it consulting|cfd modelling|web authoring|microsoft crm|print drivers|bioinformatic|video capture|biotechnology|digital media|merchandising|vectorization|reengineering|voice over ip|cache system|2.5g network|xprogramming|load testing|handheld crm|erecruitment|3d modelling|web services|ip telephony|online store|fpga design |web analysis|eprocurement|san switches|ic synthesis|wireless lan|asic design|it security|mp3 decoder|data mining|fixed asset|marketmaker|3g wireless|wap browser|call center|gmo testing|health care|informatica|replication|it services|web testing|egovernance|matrimonial|lotus notes|ad creation|sales order|web hosting|broadvision|commerceone|epublishing|manugistics|reinsurance|peoplesoft|jd edwards|web design|documentum|biometrics|webmethods|web mining|multimedia|child care|oracle crm|ip billing|3g network|proteomics|rental crm|ementoring|settlement|simulation|clustering|bluetooth|migration|cmm level|seebeyond|mcommerce|brokerage|mobile ip|logistics|groupware|voice xml|biometric|ecommerce|elearning|websphere|animation|oracle 11|compiler|mercator|etailing|firmware|esupport|avionics|iso 9001|iso 9000|etrainer|autodesk|weblogic|teamsite|mortgage|trunking|vignette|taxonomy|debugger|offshore|finacle|mfg/pro|garment|sei cmm|plm/cpc|learner|verilog|apparel|b2b crm|sun one|sap r/3|evm/pdm|vitria|cognos|ss7/ip|siebel|onsite|rubber|abap/4|coffee|tomcat|mysap|hipaa|ariba|spice|avvid|tibco|modem|corba|jcaho|rolap|quiz|.net|rtos|b2bi|vhdl|vlsi|esop|olap|abap|adsl|pstn|hrms|ites|baan|umts|mcad|soap|voip|xdsl|pdsn|wsdl|ecrm|oltp|gprs|btoc|uddi|eai|cnc|vpn|pcb|sap|pdm|bpr|vop|edi|ivr|eda|erp|dsp|uml|bpo|y2k|rup|crm|dss|atm|tea|cad|sms|scm|bpm|b2c|ngo|srm|cae|wap|cbt|kdn|dsl|cam|pms|cmm|kms|cti|cfd|ss7|c#|i2';
#print "$key_hash{'1'}";
#print "$terms";
#print "$keypat";
while ($keypat =~ /($terms)?/go)
{
  
 
  if ($1)  
  {
   #print "keys:$1<br>";
   push(@{$keypat1},$1);
}
}
#$keypat1 =~ s/(.*)\,$/$1/g;

#foreach (split /\|/,$keypat1)
#{
 # $keypat =~ s/$_//;
#}
#$keypat2 =~ s/(.*)\,$/$1/g;

#print "<tr><td>$keypat</td></tr>";
#if ($keypat){$keypat1 .= '|'.$keypat;}
untie %key_hash;
return ($keypat2);
}

sub getresults{
my ($keystr) = $_[0];
my ($keypat) = $_[1];
my ($location) = $_[2];
my ($offset) = $_[3];
my ($row_count) = $_[4];
my ($dbh,$site_rank,%url,$c,$page_rank,%loc_hash,$query2,$key,%hash,%cat_hash,$d,$e,$f,$query3,$val,$cid,$query1,$site_id,$parent,%site_hash);  
my ($site_loc_id,$site_url,$site_cat_rank,$val,$site_desc,$city,$filename);


my ($sqlstr) = "select site_id,site_cat_rank,link_str from site_cat_rank where cat_id in (".$keystr.") and site_loc_id in (".$location.") order by site_cat_rank desc limit ".$offset.",".$row_count;
print "<tr><td>$sqlstr</td></tr>";


$dbh = open_dbi();



my $linkfilename = 'valid_links_dbfile.txt';
tie (%hash, 'DB_File', $linkfilename, O_RDWR, 0444, $DB_BTREE) || die $!;

$query3= $dbh->prepare ('select site_id,site_url,site_desc,city,filename from site_master ') || die $query3->errstr;
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
my (%site_rank,%link_rank,%rank_list,$site_cat_key,%rank_total,%site_cat_hash,%link_str_hash,$link_str);
$query2 = $dbh->prepare ($sqlstr) || die $query2->errstr;
#$query2 = $dbh->prepare ( 'select site_id,site_cat_rank,link_str from site_cat_rank where cat_id in ("4-1","4-11","102-10","102-2") and site_loc_id = 33 order by site_cat_rank desc limit 0,35' ) || die $query2->errstr;
#$query2->bind_param(1, 0, 4);
#$query2->bind_param(2, 1000, 4);
$query2->execute();
my ($link,%link_hash);
while(($site_id,$site_cat_rank,$link_str)= $query2->fetchrow_array())
{
   $j++;
  $site_cat_hash{$site_id} += $site_cat_rank;
  $site_hash{$site_id}++;
   #$site_hash{$site_id} += $site_cat_rank;
  foreach $link(split (/\,/,$link_str))
  {
    $link_str_hash{$site_id}{$link}++;
  }
     
}

$query2->finish;

my ($k);
my ($filename) = '';

#foreach $key(sort {$site_hash{$b} <=> $site_hash{$a} || $site_cat_hash{$b} <=> $site_cat_hash{$a} } keys(%site_hash))
foreach $key(sort {$site_cat_hash{$b} <=> $site_cat_hash{$a} } keys(%site_hash))
{
$i++;
 #print "$i\t$url{$key}\t$loc_hash{$key}\t$site_hash{$key}\t$site_cat_hash{$key}\n";
 #print "<tr><td><a href=$url{$key}>$i.$url{$key}</a>$site_hash{$key}</td><td><font size=1>Location:$loc_hash{$key}</font></td></tr>";
 if ($url{$key} =~ /(.*?)\t(.*?)\t(.*?)\t(.*)/){
  print ' <tr>
  <td width="40%" valign="top" class="linktextlarge">'.$i.'<a href='.$1.'><b>'.$2.'<b></a>'.$3;
  $filename = $4;
  }
 %link_hash = %{ $link_str_hash{$key} };
$k = 0;
foreach $link( sort { $link_hash{$b} <=> $link_hash{$a} } keys (%link_hash))
 {
    $k++;
    if ($k <= 5){
    print "<br><a href=$hash{$link}>$hash{$link}</a><a href=http://localhost/cgi-bin/snapshot.pl?fn=$filename&linkid=$link&terms=$keypat>Snapshot</a>";
    }
    else {last;}
 }
print "</td></tr><tr><td>&nbsp;</td></tr>";
}

#$dbh->commit;
$dbh->disconnect();

  
 
 }

sub checkresults{
my ($keyref) = $_[0];
my ($location) = $_[1];
my ($offset) = $_[2];
my ($row_count) = $_[3];

my ($keystr,$query4,$dbh,$val,%cat_hash,$keypat);

my $catfilename = 'category_lookup_dbfile.txt';
tie (%cat_hash, 'DB_File', $catfilename, O_RDWR, 0444, $DB_BTREE) || die $!;
foreach $val(@{$keyref}){
$keystr .= '"'.$cat_hash{$val}.'",';
$keypat .= $val.' ';
}
$keystr =~ s/(.*)\,$/\1/g;
#$keypat =~ s/(.*)\|$/\1/g;
$keypat =~ s/\s/\+/g;




# Get the no of results using criteria
$dbh = open_dbi();

$query4= $dbh->prepare ('select count(distinct site_id) from site_cat_rank where cat_id in (".$keystr.") and site_loc_id in (".$location.")' )|| die $query4->errstr;
my ($res_count) = $query4->execute();

if ($res_count == 0) {return;}

&getresults($keystr,$keypat,$location,$offset,$row_count,$res_count);

}





sub open_dbi
{
   # Declare and initialize variables
   my $host = 'localhost';
   my $db = 'ishtaar';
   my $db_user = 'thaliath';
   my $db_password = '69dimple';

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




