#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: rep_location_master.pl
#Date started : 11/09/03
#Last Modified : 11/09/03

use strict;

use DBI;  



my ($dbh,$loc_id,$city,$state,$country,$query,$query1);  


$dbh = open_dbi();

$query = $dbh->prepare ( 'select loc_id,city,state,country from location_master ' ) || die $query->errstr;
$query->execute();
while(($loc_id,$city,$state,$country)= $query->fetchrow_array())
{
   
   $city = ucfirst($city);
   $city =~ s/(.*?)(\s\w)(.*)/$1.lc($2).$3/ge;
   $state = ucfirst($state);

   if ($state =~ /(.*?)(\s\w)(.*)/){
     #print "$1\n";
     $state = $1.uc($2).$3;}
   $country = ucfirst($country);
   #print "$loc_id\t$city\t$state\t$country\n";
  
}

$query->finish;

$query1 = $dbh->prepare ( 'update location_master set city = ?,state = ?, country = ? where loc_id = ? ' ) || die $query1->errstr;
open (F,"location.txt");
while (<F>){
 chomp;
 ($loc_id,$city,$state,$country) = split (/\t/,$_);
 #print "$loc_id\t$city\t$state\t$country\n";
  $query1->execute($city,$state,$country,$loc_id);
 }

$query1->finish;
$dbh->disconnect();
close(F);
exit 1;

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

