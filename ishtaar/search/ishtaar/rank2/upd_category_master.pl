#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: upd_category_master.pl
#Date started : 10/21/03
#Last Modified : 10/21/03
#desc: update category master table

use strict;

use DBI;  



my ($dbh,$cat_id,$cat,$query,$cat_text,$i,$subcat_id,$subcat,$k);  

$k = 0;
$dbh = open_dbi();
open (F, "categorymaster.txt") or die ("Could not open input file.");
$query = $dbh->prepare ( 'INSERT into category_master (cat_id,cat_desc,parent_id,level_no) VALUES(?,?,?,?)') || die $query->errstr;
while (<F>) {
chomp;
($cat_id,$cat,$cat_text) = split (/\t/, $_);
$query->execute($cat_id, $cat,'0',1);
$i = 0;
$k++;
#print "$cat_id\t$cat\n";
foreach $subcat(split(/\|/,$cat_text))
{
  $i++;
  $k++;
  $subcat_id = "$cat_id"."-"."$i";
  $query->execute($subcat_id, $subcat,$cat_id,2);
  #print "$subcat_id\t$subcat\t$cat_id\n";
}
}   
close F;
$query->finish;
$dbh->disconnect();
print "Total $k categories\n";
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

