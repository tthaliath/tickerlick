#!usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: in09_upd_index_by_key_db.pl
#Date started : 10/14/03
#Last Modified : 10/14/03
#desc: update index_by_key table

use strict;

use DBI;  



my ($dbh,$cid,$cat,$query);  
my ($keystr,$link_id_pos,$loc_id);

$dbh = open_dbi();
open (IFH, "termbyloc.txt") or die ("Could not open input file.");
$query = $dbh->prepare ( 'INSERT into index_by_key (key_str,loc_id, link_id_pos) VALUES(?,?,?)') || die $query->errstr;
while (<IFH>) {
chomp;

($keystr,$loc_id, $link_id_pos) = split /\t/, $_;
#print "$keystr\n";
$query->execute($keystr, $loc_id,$link_id_pos);
#last;
}   
close IFH;
$query->finish;
#$dbh->commit();
$dbh->disconnect();

sub open_dbi
{
   # Declare and initialize variables
   my $host = 'localhost';
   my $db = 'ishtaar';
   my $db_user = 'istrtest';
   my $db_password = 'istrtest';

   # Connect to the requested server

   my $dbh = DBI->connect("dbi:mysql:$db:$host", "$db_user", "$db_password" ) 
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

