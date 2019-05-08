#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: in14_upd_link_category.pl
#Date started : 10/21/03
#Last Modified : 10/21/03
#Purpose : Store the contents of an index category files into link_category table

use strict;

use DBI;  
my ($keyword,$key);
my ($page_id,$cnt,$catid,$cid,$dbh,$cat,$query1,$query2,$parent);
my (%hash1,%hash2,$k,$rem);
my $data_dir = "indexcat/" ;
my $fullname;
my $file;
my ($in,$header);
my @sub_list;
my $i = 0;

open (OUT, ">in14_err_log.txt");
$dbh = open_dbi();
$query1 = $dbh->prepare ('select cat_id,cat_desc,parent_id from category_master where level_no = 2') || die $query1->errstr;
$query1->execute();
while(($cid,$cat,$parent)= $query1->fetchrow_array())
{
    
   $cat =~ s/\\//g;
   $hash1{$cat} = $cid;
   $hash2{$cat} = $parent;
}

$query1->finish;

$query2 = $dbh->prepare ( 'INSERT into link_category (link_id,cat_id,cat_parent_id,cat_cnt) VALUES(?,?,?,?)') || die $query2->errstr;
opendir (DIR, $data_dir) ;
while (defined($file = readdir(DIR))){
  if ($file =~ /\.txt/) {
    push (@sub_list,$data_dir.$file);
    
  }
}
closedir (DIR);
my $filename;
$k = 0;
foreach $filename(@sub_list)
{
 $i++;
 #print "$i\t$filename\n";
 open (F,"<$filename");
 while (<F>){
 chomp;
  $k++;
 ($page_id,$keyword,$catid,$cnt) = split (/\t/,$_);
  $keyword =~ s/\s+$//;
  if (!$hash1{$keyword}){
 print OUT "cat:$filename\t$page_id\t$hash1{$keyword}\t$hash2{$keyword}\t$cnt\t$keyword\n";}
 if (!$hash2{$keyword}){
 print OUT  "parent:$filename\t$page_id\t$hash1{$keyword}\t$hash2{$keyword}\t$cnt\t$keyword\n";}
 if (!$catid){print OUT  "NO CATID\tparent:$filename\t$page_id\t$hash1{$keyword}\t$hash2{$keyword}\t$cnt\t$keyword\n";}
 #$query2->execute($page_id,$hash1{$keyword},$hash2{$keyword},$cnt);
}   
close(F);
}
$query2->finish;
$dbh->disconnect();
close (OUT);

print "total terms: $k\n";
                           
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




 
