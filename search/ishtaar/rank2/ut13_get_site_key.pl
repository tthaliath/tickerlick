#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: ut13_get_site_cat.pl
#Date started : 11/03/03
#Last Modified : 11/03/03
#purpose : get site and keyword from site_key_rank table
use strict;
use DBI;  

my ($i,$dbh,$query2,$site_id,$cat_id);
$dbh = open_dbi();
$query2 = $dbh->prepare ( 'select site_id,keyword from site_key_rank ') || die $query2->errstr;
open (OUT,">site_key.txt");
$query2->execute();
while(($site_id,$cat_id)= $query2->fetchrow_array())
{
   print OUT "$site_id\t$cat_id\n";
   $i++;
}
close (OUT);
$query2->finish;

print "$i records\n";

#$dbh->commit;
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

