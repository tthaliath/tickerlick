#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: upd_category_master_web.pl
#Date started : 10/21/03
#Last Modified : 10/21/03
#desc: update category master table

use strict;

use DBI;  



my ($dbh,$cat_id,$cat,$query,$cat_text,$i,$subcat_id,$subcat,$k);  

$k = 0;
$dbh = open_dbi();
open (F, "category_master_web.txt") or die ("Could not open input file.");
$query = $dbh->prepare ( 'INSERT into category_master_web (cat_id,cat_desc,parent_id,level_no,cat_id_add,disp_flag) VALUES(?,?,?,?,?,?)') || die $query->errstr;
while (<F>) {
chomp;
($cat_id,$cat_desc,$parent_id,$level) = split (/\t/, $_);
$query->execute($cat_id, $cat,'0',1);
$i = 0;
$k++;
#print "$cat_id\t$cat\n";
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
   my $db_user = 'thaliath';
   my $db_password = '69dimple';

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

