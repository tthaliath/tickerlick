#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: cr_cat_html.pl
#Date started : 11/11/03
#Last Modified : 11/11/03

use strict;

use DBI;  # Here's how to include the DBI module 



my ($dbh,$cat_id,$cat,$query,$cat_text,$cat_desc,$subcat,$k,$query1,%hash,$i,$cat_order);  
$dbh = open_dbi();
$query1 = $dbh->prepare ( 'select cat_desc from category_master where cat_id = ? ') || die $query1->errstr;
my ($databuf) = '';
$k =0;
$databuf .= '<td width="34%" valign="top" class="bluetextheader">';
open (F, "catmain.txt") or die ("Could not open input file.");

while (<F>) {
chomp;
($cat_id,$cat,$cat_text,$cat_order) = split (/\t/, $_);

$hash{$cat_order} = "$cat_id\t$cat\t$cat_text";
}
foreach $cat_order(sort {$a <=> $b} keys(%hash))
{
#print "$cat_order\n";
($cat_id,$cat,$cat_text) = split (/\t/,$hash{$cat_order});
$k++;
$i = 0;
if ($k % 10 ==0){$databuf .= '</td><td width="34%" valign="top" class="bluetextheader">';} 
$databuf .= '<br><a href="http://localhost/cgi-bin/searchbycategory.pl?cid='.$cat_id.'"><b>'.$cat.'</b></a><br>';
foreach $subcat(split(/\,/,$cat_text))
{
  $i++;
  if ($i % 2 ==0){$databuf .='<br>';}
  #$query1->bind_param(1, $subcat, 5);
   $query1->execute($subcat);
   ($cat_desc) = $query1->fetchrow_array();
   $cat_desc = ucfirst($cat_desc);
   $cat_desc =~ s/(.*?)(\s\w)(.*)/$1.uc($2).$3/ge;
   $cat_desc =~ s/(.*)(\s\w)(.*)/$1.uc($2).$3/ge;
  # print "$subcat\t$cat_desc\n";
  $databuf .= '<a href="http://localhost/cgi-bin/searchbycategory.pl?cid='.$subcat.'">'.$cat_desc.'</a> &nbsp;';
}
}   
close F;
$databuf .= "</td>";
$query1->finish;
$dbh->disconnect();
print "$databuf\n";
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
   die "$error_message\nERROR: $DBI::err ($DBI::errstr)\n";
}#end: err_trap


