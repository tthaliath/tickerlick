#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: db06_cr_valid_links_dbfile.pl
#Date started : 10/28/03
#create linkmaster DB file from valid links table

use strict;
use DB_File;
use DBI;


my $linkfilename;
my ($url,$link_id,%hash,$dbh,$query1,$page_title);


my $i = 0;
system('rm valid_links_dbfile.txt');
my $linkfilename = 'valid_links_dbfile.txt';
tie (%hash, 'DB_File', $linkfilename, O_CREAT|O_RDWR, 0644, $DB_BTREE) || die $!;

$dbh = open_dbi();
$query1 = $dbh->prepare ('select link_id,url,page_title from valid_link_master ') || die $query1->errstr;
$query1->execute();
while(($link_id,$url,$page_title)= $query1->fetchrow_array())
{
    $i++;
   #if ($link_id =~ /^597/){print "$link_id\t$url\n";}
 
   $hash{$link_id} = "$url\t$page_title";
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

