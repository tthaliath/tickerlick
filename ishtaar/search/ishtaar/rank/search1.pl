#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: search1.pl
#Date started : 11/03/03
#Last Modified : 11/03/03
#desc :   get the sites matching a query sorted by relevance
use strict;
use DB_File;
use DBI;  

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

$query2 = $dbh->prepare ( 'select site_id,site_cat_rank,link_str from site_cat_rank where cat_id in ("53-4") and site_loc_id = 33') || die $query2->errstr;
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
  foreach $link(split (/\,/,$link_str)){
    $link_str_hash{$site_id}{lc $link}++;
  }
     
}

$query2->finish;

my ($k);
foreach $key(sort {$site_hash{$b} <=> $site_hash{$a} || $site_cat_hash{$b} <=> $site_cat_hash{$a} } keys(%site_hash))
{
  $i++;
print "$i\t$url{$key}\t$loc_hash{$key}\t$site_hash{$key}\t$site_cat_hash{$key}\n";
%link_hash = %{ $link_str_hash{$key} };
$k = 0;
foreach $link( sort { $link_hash{$b} <=> $link_hash{$a} } keys (%link_hash))
 {
    $k++;
    if ($k <= 5){
    print "$hash{$link}\t$link_hash{$link}\n";
    }
    else {last;}
 }
}

#$dbh->commit;
$dbh->disconnect();

print "total rows: $j\n";
exit 1;

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

