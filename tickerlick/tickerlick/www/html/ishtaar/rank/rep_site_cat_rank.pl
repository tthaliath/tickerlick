#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: rep_site_cat_rank.pl
#Date started : 10/29/03
#Last Modified : 10/29/03
#desc :  A report to calculate the site-category rank.
use strict;
use DB_File;
use DBI;  

my ($dbh,$a,$b,$site_rank,%url,$c,$page_rank,$query2,$key,%hash,%hash1,$d,$e,$f,$query3,$val,$cid,$query1,$site_id,$cat,$site_hash,$site_desc,%site_hash);  


$dbh = open_dbi();
$query1 = $dbh->prepare ('select cat_id,cat_desc from category_master ') || die $query1->errstr;
$query1->execute();
while(($cid,$cat)= $query1->fetchrow_array())
{
    
 
   $hash1{$cid} = $cat;
}

$query1->finish;

$query3= $dbh->prepare ('select site_id,site_url,site_rank from site_master ') || die $query3->errstr;
$query3->execute();
while(($site_id,$site_desc,$site_rank)= $query3->fetchrow_array())
{
    
   
   $site_hash{$site_id} = $site_rank;
   $url{$site_id} = $site_desc;
}

$query3->finish;

my ($i) = 0;

$query2 = $dbh->prepare ( 'select site_id,cat_id,count(*),sum(link_cat_rank) from link_cat_rank where site_loc_id = 33 and cat_id = "1-1" group by site_id,cat_id order by cat_id' ) || die $query2->errstr;

$query2->execute();
while(($a,$b,$c,$d)= $query2->fetchrow_array())
{
   
   $i++;
   $page_rank = log(1+$site_hash{$a})*(log(1+$c)+log(1+$d));
   #$page_rank = sprintf("%d.4f",$page_rank);
   print "$i\t$url{$a}\t$hash1{$b}\t$site_hash{$a}\t$c\t$d\t$page_rank\n";
   
}

$query2->finish;

$dbh->disconnect();

print "total rows: $i\n";
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

