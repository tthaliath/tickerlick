#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: in27_upd_site_key_loc.pl
#Date started : 11/03/03
#Last Modified : 11/03/03
use strict;
use DB_File;
use DBI;  

my ($dbh,$site_rank,%url,$c,$page_rank,%loc_hash,$query2,$key,%hash,%cat_hash,$d,$e,$f,$query3,$val,$cid,$query1,$site_id,$parent,%site_hash);  
my ($site_loc_id,$site_url,$link_id,$cat_id,$k);


my ($i) = 0;
my ($query4,$city,$city_id);

$dbh = open_dbi();
$query2 = $dbh->prepare ( 'select city,city_id from location_master') || die $query2->errstr;
$query4 = $dbh->prepare ( 'update site_key_rank set city = ? where site_loc_id = ?') || die $query4->errstr;
$query2->execute();
while(($city,$city_id)= $query2->fetchrow_array()){
   $i++;
  $query4->execute($city,$city_id);
  $k = 0;
}

$query2->finish;
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

