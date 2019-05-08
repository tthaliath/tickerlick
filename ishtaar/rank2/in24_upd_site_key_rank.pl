#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: in24_upd_site_key_rank.pl
#Date started : 10/31/03
#Last Modified : 10/31/03
#desc :   calculate the site weight for a category from page rank
use strict;
use DB_File;
use DBI;  

my ($dbh,$site_rank,%url,$c,$page_rank,%loc_hash,$query2,$key,%hash,%cat_hash,$d,$e,$f,$query3,$val,$cid,$query1,$site_id,$parent,%site_hash);  
my ($site_loc_id,$site_url,$keyword,$site_key_rank,$site_size,%size_hash);

$dbh = open_dbi();
$query1 = $dbh->prepare ('select cat_id,parent_id from category_master ') || die $query1->errstr;
$query1->execute();
while(($cid,$parent)= $query1->fetchrow_array())
{
    
 
   $cat_hash{$cid} = $parent;
}

$query1->finish;

$query3= $dbh->prepare ('select site_id,site_url,site_rank,site_loc_id,site_size from site_master ') || die $query3->errstr;
$query3->execute();
while(($site_id,$site_url,$site_rank,$site_loc_id,$site_size)= $query3->fetchrow_array())
{
    
   if (!$site_rank){$site_rank = 1}; 
   $site_hash{$site_id} = $site_rank;
   $loc_hash{$site_id} = $site_loc_id;
   $size_hash{$site_id} = $site_size;
   $url{$site_id} = $site_url;
}

$query3->finish;

my ($i) = 0;
my (%site_rank,%link_rank,%rank_list,$site_cat_key,%rank_total);

$query2 = $dbh->prepare ( 'select site_id,keyword,sum(link_key_rank) from link_key_rank where site_id > 500 group by site_id,keyword' ) || die $query2->errstr;

$query2->execute();
while(($c,$d,$e)= $query2->fetchrow_array())
{
  
   #if (!$e){$e = 1;} 
   $site_cat_key = $c."_".$d;
   $link_rank{$site_cat_key} = $e || 0;
   $site_rank{$site_cat_key} = $site_hash{$c} || 0;
   #$site_rank{$c} *= log(1+$link_rank{$c});
   $rank_total{$site_cat_key} += log ($site_rank{$site_cat_key}*$link_rank{$site_cat_key});
   
}

$query2->finish;


foreach $key(keys(%site_rank))
{
   #$rank_list{$key} = $site_rank{$key}/$rank_total;
   #$rank_list{$key} = $link_rank{$key}/$rank_total;
   $rank_list{$key} = (log($site_rank{$key})/(1+$rank_total{$key}))* $link_rank{$key};
   #$rank_list{$key} = ($site_rank{$key}/$rank_total{$key})* $link_rank{$key};
}
my ($site_cat_rank,$query4);
$query4 = $dbh->prepare ( 'insert into site_key_rank set site_id = ?, site_loc_id = ?, keyword = ?, site_key_rank =?,site_size = ? ') || die $query3->errstr;
foreach $key( keys(%rank_list))
{
   $i++;
   ($site_id,$cid) = split (/_/,$key);
   $site_cat_rank = sprintf('%.4f',$rank_list{$key});
   $query4->execute($site_id,$loc_hash{$site_id},$cid,$site_cat_rank,$size_hash{$site_id});
  #print "$i\t$site_id\t$url{$site_id}\t$cid\t$loc_hash{$site_id}\t$site_cat_rank\t$link_rank{$key}\t$site_hash{$site_id}\n";
}


$query4->finish;
#$dbh->commit;
$dbh->disconnect();

print "total rows: $i\n";
exit 1;

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

