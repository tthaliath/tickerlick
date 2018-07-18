#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: in25_ upd_title_linktext_rank.pl
#Date started : 10/22/03
#Last Modified : 10/22/03

use strict;

use DBI;  

my ($link_id,$link_text,$page_title);
my ($dbh,$a,$b,$c,$query1,$key,%hash,$query2,$cid,$cat,$query3);  
my ($flag1,$flag2,$link_text_cat,$page_title_cat);
my ($i) = 0;
$dbh = open_dbi();
$query1 = $dbh->prepare ('select cat_id,cat_desc from category_master ') || die $query1->errstr;
$query1->execute();
while(($cid,$cat)= $query1->fetchrow_array())
{
    
   #print"$cid\t$cat\n";
   #$cat =~ s/\\//g;
   $hash{$cid} = $cat;
}

$query1->finish;
$query2 = $dbh->prepare ( 'select link_id,link_text,page_title from valid_link_master ') || die $query2->errstr;
$query3 = $dbh->prepare ( 'update valid_link_master set link_text_cat = ?, page_title_cat = ? where link_id = ? ') || die $query3->errstr;
#$query2 = $dbh->prepare ( 'select cid,categories from company_category where categories regexp ? ' ) || die $query2->errstr;
$query2->execute();
while(($link_id,$link_text,$page_title)= $query2->fetchrow_array())
{
   
   $i++;
   $flag1 = 0;
   $flag2 = 0;
   $link_text_cat = '';
   $page_title_cat = '';
   foreach $cid(keys (%hash))
   {

     if ($link_text =~ /\b$hash{$cid}\b/i){$link_text_cat= $cid;$flag1 = 1;}
     if ($page_title =~ /\b$hash{$cid}\b/i){$page_title_cat = $cid;$flag2 = 1;}
     if ($flag1 && $flag2){next;}
 }

#print "$link_id\t$link_text\t$link_text_cat\t$page_title\t$page_title_cat\n";
if ($link_text_cat || $page_title_cat){$query3->execute($link_text_cat,$page_title_cat,$link_id);}
}


$query2->finish;
$query3->finish;
$dbh->commit;
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

