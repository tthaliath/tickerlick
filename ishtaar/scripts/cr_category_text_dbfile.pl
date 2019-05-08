#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: cr_category_text_dbfile.pl
#Date started : 11/07/03
#create category master text DB file from category_master table

use strict;
use DB_File;
use DBI;


my $linkfilename;
my ($cat_desc,$cat_id,%hash,$dbh,$query1);


my $i = 0;
system('rm category_text_dbfile.txt');
my $catfilename = 'category_text_dbfile.txt';
tie (%hash, 'DB_File', $catfilename, O_CREAT|O_RDWR, 0644, $DB_BTREE) || die $!;
my ($cat_text) = '';
$dbh = open_dbi();
$query1 = $dbh->prepare ('select cat_id,cat_desc from category_master where level_no = 2') || die $query1->errstr;
$query1->execute();
while(($cat_id,$cat_desc)= $query1->fetchrow_array())
{
    $i++;
 
   $cat_text .= $cat_desc.'|';
}
$cat_text =~ s/(.*)\|$/\1/g;
$query1->finish;
$dbh->disconnect();
$hash{1} = $cat_text;
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

