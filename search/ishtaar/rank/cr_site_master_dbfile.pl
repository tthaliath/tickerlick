#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: cr_site_master_dbfile.pl
#Date started : 10/28/03
#create linkmaster DB file from valid links table

use strict;
use DB_File;
use DBI;


my $linkfilename;
my ($site_url,$site_id,%hash,$dbh,$query1);


my $i = 0;
system('del site_master_dbfile.txt');
my $sitefilename = 'site_master_dbfile.txt';
tie (%hash, 'DB_File', $sitefilename, O_CREAT|O_RDWR, 0644, $DB_BTREE) || die $!;

$dbh = open_dbi();
$query1 = $dbh->prepare ('select site_id,site_url from site_master ') || die $query1->errstr;
$query1->execute();
while(($site_id,$site_url)= $query1->fetchrow_array())
{
    $i++;
 
   $hash{$site_id} = $site_url;
}

$query1->finish;
$dbh->disconnect();
untie %hash;
print "$i links processed\n";
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

