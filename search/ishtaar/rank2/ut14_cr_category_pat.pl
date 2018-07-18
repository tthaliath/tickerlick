#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: cr_category_pat.pl
#Date started : 11/07/03
#create category pattern from category_master table

use strict;
use DB_File;
use DBI;

require "ut15_stemmer.pl";

my $linkfilename;
my ($i,$cat_desc,$cat_id,$key,%hash,$dbh,$query1);


open (OUT,">cat_pat.txt");
$dbh = open_dbi();
$query1 = $dbh->prepare ('select cat_desc from category_master ') || die $query1->errstr;
$query1->execute();
my ($cat_str,$key_str);
while(($cat_desc)= $query1->fetchrow_array())
{
   #print "$cat_desc\n";
   $i++; 
   $cat_str = '';
   if ($cat_desc =~ /\s+/){
   foreach $key (split (/\s+/,$cat_desc)){
   $key = stem($key);
   if ($cat_str){$cat_str .= " ".$key;}
   else {$cat_str = $key;}
   }
   }
   #else { $cat_str = stem($cat_desc);}
   if (!$hash{$cat_str}){
    $key_str .= $cat_str."|";
    $hash{$cat_str}++;
   } 

}

print "$i retrieved\n";

print OUT "$key_str";
 
close (OUT);
$query1->finish;
$dbh->disconnect();
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

