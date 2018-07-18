#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: rep_link_category.pl
#Date started : 10/21/03
#Last Modified : 10/21/03

use strict;

use DBI;  


my ($dbh,$a,$b,$c,$query1,$key,%hash,$query2,$cid,$cat);  

my ($i) = 0;
$dbh = open_dbi();
$query1 = $dbh->prepare ('select cat_id,cat_desc from category_master ') || die $query1->errstr;
$query1->execute();
while(($cid,$cat)= $query1->fetchrow_array())
{
    
   #print"$cid\t$cat\n";
   $cat =~ s/\\//g;
   $hash{$cid} = $cat;
}

$query1->finish;
$query2 = $dbh->prepare ( 'select link_id,cat_parent_id,sum(cat_cnt) from link_category where link_id regexp  "^105-.*" group by cat_parent_id,link_id ' ) || die $query2->errstr;
#$query2 = $dbh->prepare ( 'select cid,categories from company_category where categories regexp ? ' ) || die $query2->errstr;
$query2->execute();
while(($a,$b,$c)= $query2->fetchrow_array())
{
   
   $i++;

   print "$i\t$a\t$hash{$b}\t$c\n";
   
}

$query2->finish;

$dbh->disconnect();

exit 1;

sub open_dbi
{
   # Declare and initialize variables
   my $host = 'localhost';
   my $db = 'ishtaar';
   my $db_user = 'thaliath';
   my $db_password = '69dimple';

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

