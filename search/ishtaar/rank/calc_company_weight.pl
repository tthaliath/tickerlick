#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: calc_company_weight.pl
#Date started : 10/31/03
#Last Modified : 10/31/03
#desc :  A report to calculate the site weight for a category from page rank
use strict;
use DB_File;
use DBI;  

my ($dbh,$site_rank_log,%url,$c,$page_rank,$query2,$key,%hash,%hash1,$d,$e,$f,$query3,$val,$cid,$query1,$site_id,$cat,$site_hash,$site_desc,%site_hash);  


$dbh = open_dbi();
$query1 = $dbh->prepare ('select cat_id,cat_desc from category_master ') || die $query1->errstr;
$query1->execute();
while(($cid,$cat)= $query1->fetchrow_array())
{
    
 
   $hash1{$cid} = $cat;
}

$query1->finish;

$query3= $dbh->prepare ('select site_id,site_url,site_rank_log from site_master where site_loc_id = 33 ') || die $query3->errstr;
$query3->execute();
while(($site_id,$site_desc,$site_rank_log)= $query3->fetchrow_array())
{
    
   
   $site_hash{$site_id} = $site_rank_log;
   $url{$site_id} = $site_desc;
}

$query3->finish;

my ($i) = 0;
my (%site_rank,%link_rank,%rank_list);
my ($rank_total) = 0;
$query2 = $dbh->prepare ( 'select site_id,sum(link_cat_rank) from link_cat_rank where site_loc_id = 33 and cat_id = "5-1" group by site_id' ) || die $query2->errstr;

$query2->execute();
while(($c,$d)= $query2->fetchrow_array())
{
   
   
   $link_rank{$c} = $d || 0;
   $site_rank{$c} = $site_hash{$c} || 0;
   #$site_rank{$c} *= log(1+$link_rank{$c});
   $rank_total += $site_rank{$c}+log($link_rank{$c});
   
   
}

$query2->finish;

$dbh->disconnect();

foreach $key(keys(%site_rank))
{
   #$rank_list{$key} = $site_rank{$key}/$rank_total;
   #$rank_list{$key} = $link_rank{$key}/$rank_total;
   $rank_list{$key} = (1 + ($site_rank{$key}/$rank_total))* $link_rank{$key};
}

foreach $key(sort {$rank_list{$b} <=> $rank_list{$a} } keys(%rank_list))
{
   $i++;
   print "$i\t$url{$key}\t$rank_list{$key}\t$link_rank{$key}\t$site_hash{$key}\n";
}

print "total rows: $i\n";
print "rank total: $rank_total\n";
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

