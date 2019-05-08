#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: db01_insert_location_master.pl 
#Date started : 11/26/03
#Last Modified : 11/26/03
#desc: insert location_master;

use strict;
use DBI;

my ($dbh,$query,$country_code,$country_name,$city,$city_id);  


$dbh = open_dbi();
open (IFH, "city_region_code.txt") or die ("Could not open input file.");
$query = $dbh->prepare ( 'insert into location_master(country_code,country_name,city,city_id) values (?,?,?,?)') || die $query->errstr;
while (<IFH>) {
chomp;
($country_code,$country_name,$city,$city_id) = split /\t/, $_;
#$query->bind_param(1, $country_code, SQL_VARCHAR);
#$query->bind_param(2, $country_name, SQL_VARCHAR);
$query->execute($country_code,$country_name,$city,$city_id) or warn $query->errstr(); # check for error
}   
close IFH;
$query->finish;
$dbh->disconnect();
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

