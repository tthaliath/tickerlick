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

sub prepareKeywords
{
my ($keywords) = lc shift;
my ($keypat1) = shift;
my ($keypat,$keypat2,$val,$terms);
my $i = 0;
my %stop_hash;
#$keypat = $keywords;
my @stop_words = qw/a all also an and are as at be been before but by can do does did each etc for from had has have he his i id if in inc into is it its limited ltd next not now of on or our per pvt she than that the their them then there thereby these they this those to ware was we were what when where which while who will with would you your/;
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
my ($res_count) = $_[3];
my ($offset) = $_[4] || 0;
my ($row_count) = $_[5] || 10;
my ($sortby) = $_[6] || 'R';
my ($nolinks) = $_[7] || 5;
my ($size) = $_[8] || 'all';
my ($keycnt) = $_[9] || 0;
my ($query_option) = $_[10] || 1;

$keypat =~ s/\s/\+/g;
my ($dbh,$site_rank,%url,$c,$page_rank,%loc_hash,$query2,$key,%hash,%cat_hash,$d,$e,$f,$query3,$val,$cid,$query1,$site_id,$parent,%site_hash,%texthash);  
my ($site_loc_id,@site_arr,$site_url,$site_cat_rank,$val,$site_desc,$city,$filename,$query4);
#print "<br>$keypat<br>$keystr";
$dbh = open_dbi();
my ($sqlstr1);
if ($sortby eq 'L'){ #Sort by location

if ($keycnt == 0) #Any of the keywords
{
if ($size eq "all"){ #any size
if ($location == 0){ # all locations
$sqlstr1 = "select count(site_id) a,sum(site_cat_rank) b, site_id from site_cat_rank
where cat_id in (".$keystr.") group by site_id
order by city, a desc,b desc limit ".$offset.",".$row_count;
}
else { #location
$sqlstr1 = "select count(site_id) a,sum(site_cat_rank) b, site_id from site_cat_rank 
where cat_id in (".$keystr.") and site_loc_id in (".$location.") group by site_id 
order by city, a desc,b desc limit ".$offset.",".$row_count;
}
}
else { #size matters
if ($location == 0){ # all locations
$sqlstr1 = "select count(site_id) a,sum(site_cat_rank) b, site_id from site_cat_rank
where cat_id in (".$keystr.") and site_size = ".$size." group by site_id
order by city, a desc,b desc limit ".$offset.",".$row_count;
}
else { #location
$sqlstr1 = "select count(site_id) a,sum(site_cat_rank) b, site_id from site_cat_rank
where cat_id in (".$keystr.") and site_loc_id in (".$location.") and site_size = ".$size." group by site_id
order by city, a desc,b desc limit ".$offset.",".$row_count;
}
}
}
else # All of the keywords
{
if ($size eq "all"){ #any size
if ($location == 0){ # all locations
 $sqlstr1 = "select count() a,sum(site_cat_rank) b, site_id from site_cat_rank
where cat_id in (".$keystr.") group by site_id having count(site_id) = ".$keycnt." order by city, b desc limit ".$offset.",".$row_count;
}
else { #location
 $sqlstr1 = "select count(site_id) a,sum(site_cat_rank) b, site_id from site_cat_rank 
where cat_id in (".$keystr.") and site_loc_id in (".$location.") group by site_id 
having count(site_id) = ".$keycnt." order by city, b desc limit ".$offset.",".$row_count;
}
}
else { #size matters
if ($location == 0){ # all locations
 $sqlstr1 = "select count(site_id) a,sum(site_cat_rank) b, site_id from site_cat_rank
where cat_id in (".$keystr.") and site_size = ".$size." group by site_id having count(site_id) = ".$keycnt." order by city, b desc limit ".$offset.",".$row_count;
}
else { #location
 $sqlstr1 = "select count(site_id) a,sum(site_cat_rank) b, site_id from site_cat_rank
where cat_id in (".$keystr.") and site_loc_id in (".$location.") and site_size = ".$size." group by site_id
having count(site_id) = ".$keycnt." order by city, b desc limit ".$offset.",".$row_count;
}
}
}
}
else
{
if ($keycnt == 0) #Any of the keywords
{
if ($size eq "all"){ #any size
if ($location == 0){ # all locations
$sqlstr1 = "select count(site_id) a,sum(site_cat_rank) b, site_id from site_cat_rank
where cat_id in (".$keystr.")  group by site_id order by a desc,b desc limit ".$offset.",".$row_count;
}
else { #location
  $sqlstr1 = "select count(site_id) a,sum(site_cat_rank) b, site_id from site_cat_rank 
where cat_id in (".$keystr.") and site_loc_id in (".$location.") group by site_id 
order by a desc,b desc limit ".$offset.",".$row_count;
}
}
else { #size matters
if ($location == 0){ # all locations
$sqlstr1 = "select count(site_id) a,sum(site_cat_rank) b, site_id from site_cat_rank
where cat_id in (".$keystr.") and site_size = ".$size." group by site_id order by a desc,b desc limit ".$offset.",".$row_count;
}
else { #location
  $sqlstr1 = "select count(site_id) a,sum(site_cat_rank) b, site_id from site_cat_rank
where cat_id in (".$keystr.") and site_loc_id in (".$location.") and site_size = ".$size." group by site_id
order by a desc,b desc limit ".$offset.",".$row_count;
}
}
}
else # All of the keywords
{

#print "<br>$keycnt";
if ($size eq "all"){ #any size
if ($location == 0){ # all locations
 $sqlstr1 = "select count(site_id) a,sum(site_cat_rank) b, site_id from site_cat_rank
where cat_id in (".$keystr.") group by site_id having count(site_id) = ".$keycnt." order by b desc limit ".$offset.",".$row_count;
}
else { 
 $sqlstr1 = "select count(site_id) a,sum(site_cat_rank) b, site_id from site_cat_rank 
where cat_id in (".$keystr.") and site_loc_id in (".$location.") group by site_id 
having count(site_id) = ".$keycnt." order by b desc limit ".$offset.",".$row_count; 
}
}
else { #size matters
if ($location == 0){ # all locations
 $sqlstr1 = "select count(site_id) a,sum(site_cat_rank) b, site_id from site_cat_rank
where cat_id in (".$keystr.") and site_size = ".$size." group by site_id having count(site_id) = ".$keycnt." order by b desc limit ".$offset.",".$row_count;
}
else {
 $sqlstr1 = "select count(site_id) a,sum(site_cat_rank) b, site_id from site_cat_rank
where cat_id in (".$keystr.") and site_loc_id in (".$location.") and site_size = ".$size." group by site_id
having count(site_id) = ".$keycnt." order by b desc limit ".$offset.",".$row_count;
}
}
}
}
#print "<tr><td>$sqlstr1</td></tr>";
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
$sqlstr = "select site_id,link_str from site_cat_rank where cat_id in (".$keystr.") and site_id in (".$sitelist.")";
}
else { #location
$sqlstr = "select site_id,link_str from site_cat_rank where cat_id in (".$keystr.") and site_loc_id in (".$location.") and site_id in (".$sitelist.")";
}
#print "<tr><td>$sqlstr</td></tr>";

my $linkfilename = 'valid_links_dbfile.txt';
tie (%hash, 'DB_File', $linkfilename, O_RDWR, 0444, $DB_BTREE) || die $!;

my $linktextfilename = 'link_key_text_dbfile.txt';
tie (%texthash, 'DB_File', $linktextfilename, O_RDWR, 0444, $DB_BTREE) || die $!;

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
my (%cat_hash,$keypat1);
my ($k,$upperlimit);
my ($filename) = '';
my ($keytext,$patnew,$pat1,$pat);
my $stop_words = "a all also an and are as at be been before but by can do each etc for from had has have he his how however i id if in inc into is it its limited ltd next not now of on or our per pvt she than that the their them then there thereby these they this those to ware was we were what when whenever where wherever which while who will with would you your";
my $stopwords = join("\|",split(/\s/,$stop_words));
my $catfilename = 'category_desc_lookup_dbfile.txt';
tie (%cat_hash, 'DB_File', $catfilename, O_RDWR, 0444, $DB_BTREE) || die $!;
foreach $val(split(/\|/,$keypat)){
$keypat1 .= $cat_hash{$val}.'|';
}
untie %cat_hash;
$keypat1 =~ s/(.*)\|$/\1/g;
#print "<br>keypat1:$keypat1\n";
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

print "<table><tr><td><SPAN class='bluetextbold'>Web Results ".($offset+1)."-".$upperlimit."</span> of ".$res_count.".<br><br></td></tr>"; 
foreach $key (@site_arr)
{



 if ($url{$key} =~ /(.*?)\t(.*?)\t(.*?)\t(.*)/){
  #print "<br>$1&nbsp;$2&nbsp;$3\n";
  print ' <tr>
  <td width="40%" valign="top" colspan=1><a href='."http://".$1.'><span class="bluekeytext">'.$2.'</span></a>&nbsp;&nbsp;'.$3;
  $filename = $4;
  }
 %link_hash = %{ $link_str_hash{$key} };
$k = 0;
if ($query_option == 2){ # All of the keywords
foreach $link( sort { $link_hash{$b} <=> $link_hash{$a} } keys (%link_hash))
 {
    #print "<br>$hash{$link}\n";
    ($page_link,$page_title) = split (/\t/,$hash{$link});
    $k++;
    if ($k <= $nolinks){
    $filename =~ s/\s+//g;
     
     $keytext = '';
     $patnew = '';
     $pat1 = '';
     $keypat1 =~ s/\+/ /g;
    foreach $pat(split(/\|/,$keypat1)){
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
    $keypat1 =~ s/\s/\+/g;
     if (length($page_title) > 60)
     {
        $page_title = substr($page_title,0,index($page_title," ",60));
        #$page_title =~ s/(.*){60}(.*?)\s/\1\2/;
        #$page_title =~ s/(.*)\s+$/\1/g;
     }
     print "<br><class=\"linktextsize\">$keytext</class><br><a href=$hash{$link}><span class=\"bluekeytextsmall\">$page_title</span></a>&nbsp;&nbsp;<a href=/cgi-bin/snapshot.pl?fn=$filename&linkid=$link&terms=$keypat1&cat=0><span class=\"bluekeytextsmall\">Cached</span></a>";
    }
    else {last;}
 }
}
else{ #any of the keywords
foreach $link( sort  {sortlinkbykeyword1($link_hash{$b}) <=> sortlinkbykeyword2($link_hash{$a}) ||  $link_hash{$b} <=> $link_hash{$a} } keys (%link_hash))
 {
    #print "<br>$hash{$link}\n";
    ($page_link,$page_title) = split (/\t/,$hash{$link});
    $k++;
    if ($k <= $nolinks){
    $filename =~ s/\s+//g;
     $keytext = '';
    $patnew = '';
     $pat1 = '';
    $keypat1 =~ s/\+/ /g;
    foreach $pat(split(/\|/,$keypat1)){
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
    $keypat1 =~ s/\s/\+/g;
    if (length($page_title) > 60)
     {
         $page_title = substr($page_title,0,index($page_title," ",60));
         #$page_title =~ s/(.*){60}(.*?)\s/\1\2/;
       # $page_title =~ s/(.*)\s+$/\1/g;
     }
     print "<br><class=\"linktextsize\">$keytext</class><br><a href=$hash{$link}><span class=\"bluekeytextsmall\">$page_title</span></a>&nbsp;&nbsp;<a href=/cgi-bin/snapshot.pl?fn=$filename&linkid=$link&terms=$keypat1&cat=0><span class=\"bluekeytextsmall\">Cached</span></a>";
    }
    else {last;}
 }
}
}
print '</td></tr></table></TD><TD>&nbsp;</TD><TD valign="top">';

#Print links to results page

my ($res_limit) = 0;
my ($j) = 0;
my ($new_offset) = 0;
my ($next_offset,$prev_offset);
if ($res_count > $row_count)
{
  print '<table width=100% cellpadding=0 cellspacing=0 border=0 >
<tr><td rowspan=5>&nbsp;&nbsp;</td><td width=1 bgcolor=#c9d7f1 rowspan=5><img width=1 height=1 alt=""></td><td rowspan=5>&nbsp;&nbsp;</td>
<td rowspan="5" bgcolor=#c9d7f1>Sponsored Links
</td></tr>
</table>
</TD>
    </TR>
	<tr><td colspan="3"><table align="center" ><tr><td><b>Results Page:<b></td>';
  if ($offset > 0)
  {
    $prev_offset = $offset - $row_count;
    print "<td><a href=/cgi-bin/search.pl?fr=$prev_offset&catid=$keystr&catstr=$keypat&lid=$location&rc=$row_count&rt=$res_count&pt=RESULT&cs=$size&nl=$nolinks&kc=$keycnt&so=$sortby&q_o=$query_option>Previous</a></td>"; 
    print "<td><a href=/cgi-bin/search.pl?fr=$prev_offset&catid=$keystr&catstr=$keypat&lid=$location&rc=$row_count&rt=$res_count&pt=RESULT&cs=$size&nl=$nolinks&kc=$keycnt&so=$sortby&q_o=$query_option><img src='/images/ar_prev.gif' border=0 alt='Previous'></a></td>";
}
while($res_limit <= $res_count)
{
 $j++;
 $next_offset = $offset + $row_count; 
 if ($offset == $res_limit) { # Current page
  print "<td>$j</td>";
 }
 else
  {
    print "<td><a href=/cgi-bin/search.pl?fr=$new_offset&catid=$keystr&catstr=$keypat&lid=$location&rc=$row_count&rt=$res_count&pt=RESULT&cs=$size&nl=$nolinks&kc=$keycnt&so=$sortby&q_o=$query_option>$j</a></td>";
    } 
  $res_limit += $row_count;
  $new_offset += $row_count;
}
if ($next_offset < $res_count){
#PRINT next

print "<td><a href=/cgi-bin/search.pl?fr=$next_offset&catid=$keystr&catstr=$keypat&lid=$location&rc=$row_count&rt=$res_count&pt=RESULT&cs=$size&nl=$nolinks&kc=$keycnt&so=$sortby&q_o=$query_option><img src='/images/ar_next.gif' border=0 alt='Next'></a></td>";
print "<td><a href=/cgi-bin/search.pl?fr=$next_offset&catid=$keystr&catstr=$keypat&lid=$location&rc=$row_count&rt=$res_count&pt=RESULT&cs=$size&nl=$nolinks&kc=$keycnt&so=$sortby&q_o=$query_option>Next</a></td>";
}
print "</tr></table></td></tr>";

}
else {print '&nbsp;</TD></TR>';}
#$dbh->commit;
$dbh->disconnect();
untie %hash;
untie %texthash;
  
 
 }

sub checkresults{
my ($keyref) = $_[0];
my ($location) = $_[1];
my ($offset) = $_[2] || 0;
my ($row_count) = $_[3] || 10;
my ($query_option) = $_[4] || 2;
my ($sortby) = $_[5] || 'R';
my ($nolinks) = $_[6] || 5;
my ($size) = $_[7] || 'all';


my ($keystr,$query4,$dbh,$val,$val1,%cat_hash,$keypat,$res_count,$keycnt,$site_id,$site_cnt);
$keycnt = 0;
foreach $val(@{$keyref}){
if ($val =~ /\,/)
{
  foreach $val1 (split (/\,/,$val)){
   $keystr .= '"'.$val1.'",';
   $keypat .= $val1.'|';
   $keycnt++;
  }
}
else{
$keystr .= '"'.$val.'",';
$keypat .= $val.'|';
$keycnt++;
}
}

$keystr =~ s/(.*)\,$/\1/g;
$keypat =~ s/(.*)\|$/\1/g;

#print "<br>$keypat<br>";


# Get the no of results using criteria
$dbh = open_dbi();

my ($sqlstr);
if ($query_option == 2){ #Any of the keywords
if ($size eq "all"){ #any size
if ($location == 0){ # all locations
$sqlstr = "select count(distinct site_id) from site_cat_rank where
cat_id in (".$keystr.")";
}
else { #location
$sqlstr = "select count(distinct site_id) from site_cat_rank where 
cat_id in (".$keystr.") and site_loc_id in (".$location.")";
}
}
else { #size matters
$size = '"'.$size.'"';
if ($location == 0){ # all locations
$sqlstr = "select count(distinct site_id) from site_cat_rank where
cat_id in (".$keystr.") and site_size = ".$size;
}
else { #location
$sqlstr = "select count(distinct site_id) from site_cat_rank where
cat_id in (".$keystr.") and site_loc_id in (".$location.") and site_size = ".$size;
}
}
$keycnt = 0;

#print "<br>tom3:$sqlstr\n";

$query4= $dbh->prepare($sqlstr) || die $query4->errstr;
$query4->execute();
($res_count) = $query4->fetchrow_array();
}
else
{
if ($query_option == 1) # All of the keywords
{
if ($size eq "all"){ #any size
if ($location == 0){ # all locations
$sqlstr = "select count(site_id),site_id from site_cat_rank where
cat_id in (".$keystr.") group by site_id
having count(site_id) = ".$keycnt;
}
else {# location
  $sqlstr = "select count(site_id),site_id from site_cat_rank where 
cat_id in (".$keystr.") and site_loc_id in (".$location.") group by site_id 
having count(site_id) = ".$keycnt;
}
}
else { #size matters
$size = '"'.$size.'"';
if ($location == 0){ # all locations
$sqlstr = "select count(site_id),site_id from site_cat_rank where
cat_id in (".$keystr.") and site_size ".$size." group by site_id
having count(site_id) = ".$keycnt;
}
else {# location
  $sqlstr = "select count(site_id),site_id from site_cat_rank where
cat_id in (".$keystr.") and site_loc_id in (".$location.") and site_size = ".$size." group by site_id
having count(site_id) = ".$keycnt;
}
}


#print "<tr><td>$sqlstr</td></tr>";

$query4= $dbh->prepare($sqlstr) || die $query4->errstr;
$query4->execute();
$res_count = 0;
while (($site_cnt,$site_id) = $query4->fetchrow_array())
{
  $res_count++;
}
}
} 
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




