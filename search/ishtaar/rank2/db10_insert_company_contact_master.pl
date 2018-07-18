#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: db10_insert_company_contact_master.pl 
#Date started : 11/26/03
#Last Modified : 11/26/03
#desc: insert site_master;

use strict;
use DBI;

my ($dbh,$query,$domain_name,$country_code,$site_id,$site_url,$site_desc,$location,$filename,$site_loc_id,$site_rank,$site_rank_log,$site_size);  


$dbh = open_dbi();
open (IFH, "sitemasterrank.txt") or die ("Could not open input file.");
$query = $dbh->prepare ( 'insert into company_contact_master(site_id,site_url,site_desc,domain_name,loc_id1,country_code) values (?,?,?,?,?,?)') || die $query->errstr;
$country_code = "in";
while (<IFH>) {
chomp;
($site_id,$site_url,$site_desc,$location,$filename,$site_loc_id,$site_rank,$site_rank_log,$site_size) = split /\t/, $_;
#$query->bind_param(1, $country_code, SQL_VARCHAR);
#$query->bind_param(2, $country_name, SQL_VARCHAR);
if ($filename =~ /(.*)in$/){
$domain_name = $1;
}
$query->execute($site_id,$site_url,$site_desc,$domain_name,$site_loc_id,$country_code) or warn $query->errstr(); # check for error
#print "$site_id\t$site_url\t$domain_name\n";
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

