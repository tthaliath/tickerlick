#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: cr_link_key_dbfile.pl
#Date started : 11/07/03
#create category master lookup DB file from category_master table

use strict;
use DB_File;
use DBI;


my $linkfilename;
my ($link_id,$keyword,%hash,$dbh,$query1);


my $i = 0;
system('rm link_key_dbfile.txt');
my $catfilename = 'link_key_dbfile.txt';
tie (%hash, 'DB_File', $catfilename, O_CREAT|O_RDWR, 0644, $DB_BTREE) || die $!;

$dbh = open_dbi();
$query1 = $dbh->prepare ('select link_id,keyword from link_key ') || die $query1->errstr;
$query1->execute();
while(($link_id,$keyword)= $query1->fetchrow_array())
{
   $i++;
   if ($hash{$link_id}){$hash{$link_id} .= ",".$keyword;} 
   else {$hash{$link_id} = $keyword;}
}

$query1->finish;
$dbh->disconnect();
untie %hash;
print "$i records processed\n";
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

