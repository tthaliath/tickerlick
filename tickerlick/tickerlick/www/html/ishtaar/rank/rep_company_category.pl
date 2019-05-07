#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: rep_company_category.pl
#Date started : 10/14/03
#Last Modified : 10/14/03

use strict;

use DBI;  # Here's how to include the DBI module 



my ($dbh,$cid,$cat,$query,$key);  

my ($i) = 0;
my (%chash) = ();
my ($pat) = "java[*]|web services[*]|financial services[*]";
$dbh = open_dbi();
#$query = $dbh->prepare ( 'select cid,categories from company_category where categories regexp "^java[*][1-9]|^web services[*][1-9]" and categories regexp "cmm[*]" ' ) || die $query->errstr;
$query = $dbh->prepare ( 'select cid,categories from company_category where categories regexp ? ' ) || die $query->errstr;
$query->execute($pat);
while(($cid,$cat)= $query->fetchrow_array())
{
   
   $i++;
   print "$i\t$cid\t$cat\n";
   while ($cat =~ /$pat/gso){$chash{$cid}++;}
}

$query->finish;

$dbh->disconnect();

foreach $key(sort {$chash{$b} <=> $chash{$a} } keys(%chash)){print "$key\t$chash{$key}\n";}
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
      {RaiseError => 0, PrintError => 0} ) 
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

