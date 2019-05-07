#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: searchresultbykeynew1.pl
#Date started : 06/18/03
#Last Modified : 11/05/03
#Purpose : Search the index data file for a given keyword(s), print the result.

use strict;
use DB_File;
use DBI;  

sub prepareKeywords
{
my ($keywords) = lc shift;
my $remove_pat = 'a|all|also|an|and|are|as|at|be|been|before|but|by|can|do|each|etc|for|from|had|has|have|he|his|i|id|if|in|inc|into|is|it|its|limited|ltd|next|not|now|of|on|or|our|per|pvt|she|than|that|the|their|them|then|there|thereby|these|they|this|those|to|ware|was|we|were|what|when|where|which|while|who|will|with|would|you|your';
#$keywords =~ s/ $remove_pat / /g;
#$keywords =~ s/\s+/ /g;
my ($keypat,$keypat1,$keypat2,$val);
my $i = 0;
my %stop_hash;
#$keypat = $keywords;
my @stop_words = qw/a all also an and are as at be been before but by can do each etc for from had has have he his i id if in inc into is it its limited ltd next not now of on or our per pvt she than that the their them then there thereby these they this those to ware was we were what when where which while who will with would you your/;
foreach (@stop_words) {$stop_hash{$_}++ };
map { $keypat .= ' '.$_ }
               grep { !( exists $stop_hash{$_} ) }
               split /\s+/, $keywords;


my %key_hash;
my $keyfile = "systemdescnewhash.txt";
tie (%key_hash, 'DB_File', $keyfile, O_RDWR, 0444, $DB_BTREE) || die $!;
$keypat1 = '';
print "<tr><td>$keypat</td></tr>";
while ($keypat =~ /($key_hash{'1'})/g)
{
  if ($1){$keypat1 .= $1.'|';}
}

$keypat1 =~ s/(.*)\|$/$1/g;

foreach (split /\|/,$keypat1)
{
  $keypat =~ s/$_//;
}
#$keypat2 =~ s/(.*)\|$/$1/g;

print "<tr><td>$keypat</td></tr>";
#if ($keypat){$keypat1 .= '|'.$keypat;}
untie %key_hash;
return ($keypat1,$keypat2);
}

sub getresults{
my ($key) = shift;
my ($location) = shift;
my ($sqlstr) = "select site_id,site_cat_rank,link_str from site_cat_rank where cat_id in (".$key.") and site_loc_id in (".$location.") order by site_cat_rank desc limit 0,35";
print "<tr><td>$sqlstr</td></tr>";
my ($dbh,$site_rank,%url,$c,$page_rank,%loc_hash,$query2,$key,%hash,%cat_hash,$d,$e,$f,$query3,$val,$cid,$query1,$site_id,$parent,%site_hash);  
my ($site_loc_id,$site_url,$site_cat_rank);

my $linkfilename = 'valid_links_dbfile.txt';
tie (%hash, 'DB_File', $linkfilename, O_RDWR, 0444, $DB_BTREE) || die $!;

$dbh = open_dbi();
$query1 = $dbh->prepare ('select cat_id from category_master ') || die $query1->errstr;
$query1->execute();
while(($cid,$parent)= $query1->fetchrow_array())
{
    
 
   $cat_hash{$cid} = $parent;
}

$query1->finish;

$query3= $dbh->prepare ('select site_id,site_url,site_loc_id from site_master ') || die $query3->errstr;
$query3->execute();
while(($site_id,$site_url,$site_loc_id)= $query3->fetchrow_array())
{
    
   
   $loc_hash{$site_id} = $site_loc_id;
   $url{$site_id} = $site_url;
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

#foreach $key(sort {$site_hash{$b} <=> $site_hash{$a} || $site_cat_hash{$b} <=> $site_cat_hash{$a} } keys(%site_hash))
foreach $key(sort {$site_cat_hash{$b} <=> $site_cat_hash{$a} } keys(%site_hash))
{
$i++;
 #print "$i\t$url{$key}\t$loc_hash{$key}\t$site_hash{$key}\t$site_cat_hash{$key}\n";
 print "<tr><td><a href=$url{$key}>$i.$url{$key}</a>$site_hash{$key}</td><td><font size=1>Location:$loc_hash{$key}</font></td></tr>";

 %link_hash = %{ $link_str_hash{$key} };
$k = 0;
foreach $link( sort { $link_hash{$b} <=> $link_hash{$a} } keys (%link_hash))
 {
    $k++;
    if ($k <= 5){
    print "<tr><td><a href=$hash{$link}>$hash{$link}</a>$link_hash{$link}</td></tr>";
    }
    else {last;}
 }
print "<tr><td>&nbsp;</td></tr>";
}

#$dbh->commit;
$dbh->disconnect();

  
 
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




