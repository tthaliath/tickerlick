#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: db04_rep_location_master.pl
#Date started : 11/09/03
#Last Modified : 11/09/03

use strict;

use DBI;  



my ($dbh,$loc_id,$city,$state,$country,$query,$query1);  


$dbh = open_dbi();
open (OUT,">city_loc_in.txt");
$query = $dbh->prepare ( 'select city_id,city from location_master where country_code in ("in") order by city' ) || die $query->errstr;
$query->execute();
while(($loc_id,$city)= $query->fetchrow_array())
{
   
   #$city = ucfirst($city);
  # $city =~ s/(.*?)(\s\w)(.*)/$1.lc($2).$3/ge;
   print OUT "$loc_id\t$city\n";
  
}

$query->finish;

$dbh->disconnect();
close(OUT);
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

