#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: search_result1.pl
#Date started : 10/26/03
#Last Modified : 10/26/03
#desc : A generic program to generate report from a mysql table given table and column names.
use strict;
use DB_File;
use DBI;  

my ($dbh,$a,$b,$c,$query2,$key,%hash,%hash1,$d,$e,$f,$query3,$val,$cid,$query1,$site_id,$cat,$site_hash,$site_desc,%site_hash);  


my $linkfilename = 'valid_links_dbfile.txt';
tie (%hash, 'DB_File', $linkfilename, O_RDWR, 0444, $DB_BTREE) || die $!;

$dbh = open_dbi();
$query1 = $dbh->prepare ('select cat_id,cat_desc from category_master ') || die $query1->errstr;
$query1->execute();
while(($cid,$cat)= $query1->fetchrow_array())
{
    
 
   $hash1{$cid} = $cat;
}

$query1->finish;

$query3= $dbh->prepare ('select site_id,site_url from site_master ') || die $query3->errstr;
$query3->execute();
while(($site_id,$site_desc)= $query3->fetchrow_array())
{
    
   
   $site_hash{$site_id} = $site_desc;
}

$query3->finish;

my ($i) = 0;

$query2 = $dbh->prepare ( 'select link_id,site_id,site_loc_id, cat_id,link_cat_rank,site_rank_log from link_cat_rank where cat_parent_id = "49" order by site_rank_log desc, link_cat_rank desc' ) || die $query2->errstr;

$query2->execute();
while(($a,$b,$c,$d,$e,$f)= $query2->fetchrow_array())
{
   
   $i++;

   print "$i\t$hash{$a}\t$c\t$hash1{$d}\t$e\t$f\n";
   
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

