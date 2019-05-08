#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: rep_location_master.pl
#Date started : 11/09/03
#Last Modified : 11/09/03

use strict;

use DBI;  



my ($dbh,$query,$site_id,$site_url,$site_rank_log);  


$dbh = open_dbi();

$query = $dbh->prepare ( 'select site_id,site_url,site_rank_log from site_master order by site_rank_log desc ' ) || die $query->errstr;
$query->execute();
while(( $site_id,$site_url,$site_rank_log)= $query->fetchrow_array())
{
   
   print "$site_id\t$site_url\t$site_rank_log\n";
  
}

$query->finish;

$dbh->disconnect();
close(F);
exit 1;

sub open_dbi
{
   # Declare and initialize variables
   my $host = 'localhost';
   my $db = 'ishtaar';
   my $db_user = 'istrtest';
   my $db_password = 'istrtest';

   # Connect to the requested server

   my $dbh = DBI->connect("dbi:mysql:$db:$host", "$db_user", "$db_password", 
      {RaiseError => 0, PrintError => 0} ) 
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

