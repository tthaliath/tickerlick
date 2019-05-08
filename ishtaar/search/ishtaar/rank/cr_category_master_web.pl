#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: cr_category_master_textfile.pl
#Date started : 10/28/03
#create linkmaster DB file from category_master table

use strict;
use DB_File;
use DBI;


my $linkfilename;
my ($cat_desc,$cat_id,%hash,$dbh,$query1,$parent_id,$level_no,$cat_id_add,$disp_flag);


my $i = 0;
#system('rm category_master_textfile.txt.orig');
my $catfilename = 'category_master_web1.txt';
open (OUT, ">$catfilename");
$dbh = open_dbi();
$query1 = $dbh->prepare ('select cat_id,cat_desc,parent_id,level_no,cat_id_add,disp_flag from category_master_web ') || die $query1->errstr;
$query1->execute();
while(($cat_id,$cat_desc,$parent_id,$level_no,$cat_id_add,$disp_flag)= $query1->fetchrow_array())
{
    $i++;
    #$cat_desc =~ s/(\w+)/\u\L$1/g; 
    print OUT "$cat_id\t$cat_desc\t$parent_id\t$level_no\t$cat_id_add\t$disp_flag\n";
}

$query1->finish;
$dbh->disconnect();
untie %hash;
print "$i links processed\n";
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

