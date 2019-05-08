#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: upd_company_category.pl
#Date started : 10/14/03
#Last Modified : 10/14/03
#desc : update caompany_category table.

use strict;

use DBI;  # Here's how to include the DBI module 



my ($dbh,$cid,$cat,$query);  

my($i) = 0;
$dbh = open_dbi();
open (IFH, "3") or die ("Could not open input file.");
$query = $dbh->prepare ( 'INSERT into company_category (cid,categories) VALUES(?,?)') || die $query->errstr;
while (<IFH>) {
chomp;
$i++;
($cid,$cat) = split /\t/, $_;
$query->execute($cid, $cat);
}   
close IFH;
$dbh->commit();
$dbh->disconnect();
print "$i records inserted\n";
exit 1;

sub open_dbi
{
   # Declare and initialize variables
   my $host = 'localhost';
   my $db = 'ishtaar';
   my $db_user = 'thaliath';
   my $db_password = '69dimple';

   # Connect to the requested server

   my $dbh = DBI->connect("dbi:mysql:$db:$host", "$db_user", "$db_password", 
      {RaiseError => 0, PrintError => 0}, AutoCommit => 0 ) 
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

