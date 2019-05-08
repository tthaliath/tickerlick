#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: cr_site_master_dbfile.pl
#Date started :07/11/04
#create site master DB file from site master table

use strict;
use DB_File;
use DBI;


my $linkfilename;
my ($url,$link_id,%hash,$dbh,$query);
my ($site_id,$site_url,$site_desc,$city,$filename);


my $i = 0;
system('rm site_master_dbfile.txt');
my $linkfilename = 'site_master_dbfile.txt';
tie (%hash, 'DB_File', $linkfilename, O_CREAT|O_RDWR, 0644, $DB_BTREE) || die $!;

$dbh = open_dbi();
$query= $dbh->prepare ('select site_id,site_url,site_desc,city,filename from site_master ') || die $query->errstr;
$query->execute();
while(($site_id,$site_url,$site_desc,$city,$filename)= $query->fetchrow_array())
{
   $i++;  
   $city = ucfirst($city);
   $hash{$site_id} = "$site_url\t$site_desc\t$city\t$filename";
}

$query->finish;
$dbh->disconnect();
untie %hash;
print "$i sites processed\n";
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

