#!usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: ex02_valid_link_master.pl
#Date started : 05/31/04
#Last Modified : 05/31/04
#Purpose : export valid_link_master to a text file

use strict;
use DBI;  
  
my ($dbh,$query,$k,$sqlstr);  

my ($link_id,$url,$link_text,$page_title,$page_type,$link_text_cat,$page_title_cat);
$k = 0;
$dbh = open_dbi();
  $sqlstr = "select link_id,url,link_text,page_title,page_type,link_text_cat,page_title_cat from valid_link_master";
open (OUT,">valid_link_master_tbl.txt");

$query= $dbh->prepare($sqlstr) || die $query->errstr;
$query->execute();

while (($link_id,$url,$link_text,$page_title,$page_type,$link_text_cat,$page_title_cat) = $query->fetchrow_array())
{
  $k++;
  print OUT "$link_id\t$url\t$link_text\t$page_title\t$page_type\t$link_text_cat\t$page_title_cat\n";

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

