#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: in23_upd_link_key_rank.pl
#Date started : 10/22/03
#Last Modified : 10/22/03

use strict;

use DBI;  

my ($link_id,$link_text,$page_title,$cat_cnt,$cat_parent_id,%pagerank,$site_rank_log);
my ($dbh,$a,$b,$c,$query1,$key,%hash,$query2,$site_id,$site_loc_id,$cat_id,$query3,$query4);  
my ($link_text_rank,$link_cat_rank,$page_title_rank,$site_loc_id,$link_text_cat,$page_title_cat,$keyword,$key_cnt);
my ($i) = 0;
$dbh = open_dbi();
$query1 = $dbh->prepare ('select site_id,site_loc_id,site_rank_log from site_master ') || die $query1->errstr;
$query1->execute();
while(($site_id,$site_loc_id,$site_rank_log)= $query1->fetchrow_array())
{
    
   #print"$cid\t$cat\n";
   #$cat =~ s/\\//g;
   $hash{$site_id} = $site_loc_id;
   $pagerank{$site_id} = $site_rank_log;
}

$query1->finish;
$query2 = $dbh->prepare ( 'select link_id,keyword,key_cnt from link_key ') || die $query2->errstr;
$query3 = $dbh->prepare ( 'select link_text,page_title from valid_link_master where link_id = ?') || die $query3->errstr;
$query4 = $dbh->prepare ( 'insert into link_key_rank set link_id = ?, site_id = ?, site_loc_id = ?, keyword = ?, link_key_rank =?, site_rank_log = ? ') || die $query4->errstr;

$query2->execute();
while(($link_id,$keyword,$key_cnt)= $query2->fetchrow_array())
{
   if ($link_id =~ /(\d+)-\d+/){$site_id = $1;}
   ($link_text_cat,$page_title_cat) = $query3->execute($link_id);
   $link_cat_rank = $key_cnt || 0;
   $keyword =~ s/\\//g;
   $keyword =~ s/\+/\\\+/g;
   #print "$keyword\n";
   if ($link_text_cat =~ /$keyword/i)
  {
       $link_cat_rank += 2;
  }
  if ($page_title_cat =~ /$keyword/i)
  {
       $link_cat_rank += 2;
  }
   $i++;
   $query4->execute($link_id,$site_id,$hash{$site_id},$keyword,$link_cat_rank,$pagerank{$site_id});
}


$query2->finish;
$query3->finish;
$query4->finish;
#$dbh->commit;
$dbh->disconnect();

print "$i records inserted.\n";

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

