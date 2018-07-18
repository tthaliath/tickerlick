#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: ex03_site_master.pl
#Date started : 05/31/04
#Last Modified : 05/31/04
#Purpose : export site_master to a text file

use strict;
use DBI;  
  
my ($dbh,$query,$k,$sqlstr);  

my ($site_id,$site_url,$site_size,$site_desc,$site_rank,$site_rank_log,$city,$filename);
$k = 0;
$dbh = open_dbi();
  $sqlstr = "select site_id,site_size from site_master";
open (OUT,">site_size_tbl.txt");

$query= $dbh->prepare($sqlstr) || die $query->errstr;
$query->execute();

while (($site_id,$site_size) = $query->fetchrow_array())
{
  $k++;
  print OUT "$site_id\t$site_size\n";

}
close OUT;
$query->finish;
$dbh->disconnect();
print "Total $k records\n";
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

