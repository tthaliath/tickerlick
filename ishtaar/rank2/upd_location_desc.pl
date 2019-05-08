#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: upd_location_desc.pl
#Date started : 11/26/03
#Last Modified : 11/26/03
#desc: update city in site_cat_rank table

use strict;
use DBI qw(:sql_types);
 



my ($dbh,$lid,$city,$query);  


$dbh = open_dbi();
open (IFH, "location.txt") or die ("Could not open input file.");
$query = $dbh->prepare ( 'update site_cat_rank set city = ? where site_loc_id = ?') || die $query->errstr;
while (<IFH>) {
chomp;
($lid,$city) = split /\t/, $_;
print "$lid\t$city\n";
$query->bind_param(1, $city, SQL_VARCHAR);
$query->bind_param(2, $lid, SQL_INTEGER);
$query->execute() or warn $query->errstr(); # check for error
}   
close IFH;
$query->finish;
$dbh->disconnect();
sub open_dbi
{
   # Declare and initialize variables
   my $host = 'localhost';
   my $db = 'ishtaar';
   my $db_user = 'thaliath';
   my $db_password = '69dimple';

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

