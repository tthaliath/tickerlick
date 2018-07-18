#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File:in31_link_key_text.pl
#Date started : 10/12/03
#Last Modified : 10/15/03
#Purpose : Read the contents of files from data2 folder and update text for each keyword

use strict;
use DBI;
use DB_File;

my $fullname;
my $linkfilename;
my $file;
my ($in,$header,%hash,%hash1,$keywordnew,$fileid,$r,$rstr,$lstr,$keyword,$linktext,$query1,$dbh,$keystr,$query2,%lochash,$link_id,$site_id,$loc_id);
my @sub_list;
my $i = 0;
open (F,"<site_loc_tbl.txt");
while (<F>)
{
  chomp;
 ($site_id,$loc_id) = split (/\t/,$_);
  $lochash{$site_id} = $loc_id;
}
close (F);
$linkfilename = 'link_key_dbfile.txt';
tie (%hash, 'DB_File', $linkfilename, O_CREAT|O_RDWR, 0644, $DB_BTREE) || die $!;
my ($key,$keystr);
my ($flag) = 0;
$dbh = open_dbi();
$query2 = $dbh->prepare('update link_key set loc_id = ? where link_id = ?') || die $query2->errstr;
foreach $link_id(keys(%hash))
{
   ($site_id) = split (/-/,$link_id);
   $query2->execute($lochash{$site_id},$link_id);
   #print "$site_id\t$link_id\t$lochash{$site_id}\n";
}
$query2->finish;
$dbh->disconnect();
untie %hash;
print "$i links processed\n";

sub open_dbi
{
   # Declare and initialize variables
   my $host = 'localhost';
   my $db = 'ishtaar';
   my $db_user = 'istrtest';
   my $db_password = 'istrtest';

   # Connect to the requested server
   my $dbh = DBI->connect("dbi:mysql:$db:$host", "$db_user", "$db_password",
      {AutoCommit => 0 })
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

exit 1;
