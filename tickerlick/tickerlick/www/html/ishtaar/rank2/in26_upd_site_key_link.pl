#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: upd_site_cat_link.pl
#Date started : 11/03/03
#Last Modified : 11/03/03
#desc :   Find the most relevant links for each site-cat combination
use strict;
use DB_File;
use DBI;  

my ($dbh,$site_rank,%url,$c,$page_rank,%loc_hash,$query2,$key,%hash,%cat_hash,$d,$e,$f,$query3,$val,$cid,$query1,$site_id,$parent,%site_hash);  
my ($site_loc_id,$site_url,$link_id,$cat_id);




my ($i) = 0;
my ($link_str,$k,%site_rank,%link_rank,%rank_list,$site_cat_key,%rank_total,$query4);

$dbh = open_dbi();
#$query2 = $dbh->prepare ( 'select site_id,cat_id from site_cat_rank ') || die $query2->errstr;
$query3 = $dbh->prepare ( 'select link_id from link_key_rank where site_id = ? and keyword = ? order by link_key_rank desc') || die $query3->errstr;
$query4 = $dbh->prepare ( 'update site_key_rank set link_str = ? where site_id = ? and keyword = ?') || die $query4->errstr;
#$query2->execute();
open (F,"site_key.txt");
#while(($site_id,$cat_id)= $query2->fetchrow_array())
while (<F>)
{
  chomp;
  ($site_id,$cat_id) = split (/\t/,$_);
  # print "$site_id\t$cat_id\n";
   $i++;
  $query3->execute($site_id,$cat_id);
  $k = 0;
  $link_str = '';
  while(($link_id)= $query3->fetchrow_array())
  {
     #$k++;
     #if ($k <= 5){$link_str .= $link_id.",";}
     #if ($k == 5){next;}
     $link_str .= $link_id.",";
 }
  $link_str =~ s/(.*)\,$/\1/g;
  #print "$i\t$site_id\t$cat_id\t$link_str\n";
  $query4->execute($link_str,$site_id,$cat_id);
  #if ($i > 10){last;}
}

#$query2->finish;
$query3->finish;
$query4->finish;

print "$i records\n";

#$dbh->commit;
$dbh->disconnect();


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

