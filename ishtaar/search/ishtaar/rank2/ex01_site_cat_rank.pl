#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: ex01_site_cat_rank.pl
#Date started : 05/30/04
#Last Modified : 05/30/04
#Purpose : export site_cat_rank to a text file

use strict;
use DBI;  
  
my ($dbh,$query,$k,$sqlstr);  

my ($site_id,$site_loc_id,$cat_id,$cat_parent_id,$site_cat_rank,$link_str,$city);
$k = 0;
$dbh = open_dbi();
  #$sqlstr = "select site_id,site_loc_id,cat_id,cat_parent_id,site_cat_rank,link_str,city from site_cat_rank";
$sqlstr = "select site_id,site_cat_rank from site_cat_rank";
open (OUT,">site_cat_rank_tbl.txt");

$query= $dbh->prepare($sqlstr) || die $query->errstr;
$query->execute();

#while (($site_id,$site_loc_id,$cat_id,$cat_parent_id,$site_cat_rank,$link_str,$city) = $query->fetchrow_array())
while (($site_id,$site_cat_rank) = $query->fetchrow_array())
{
  $k++;
  #print OUT "$site_id\t$site_loc_id\t$cat_id\t$cat_parent_id\t$site_cat_rank\t$link_str\t$city\n";
print OUT "$site_id\t$site_cat_rank\n";


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

