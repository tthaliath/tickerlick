#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: in22_upd_link_term.pl
#Date started : 10/21/03
#Last Modified : 10/21/03
#Purpose : Store the contents of an index files into link_term table

use strict;

use DBI;  
my ($keyword,$key,$pos);
my ($page_id,$cnt,$catid,$cid,$dbh,$cat,$query1,$query2,$parent);
my (%hash1,%hash2,$k,$rem);
my $data_dir = "index1/" ;
my $fullname;
my $file;
my ($in,$header);
my @sub_list;
my $i = 0;

open (OUT, ">>err_log.txt");
$dbh = open_dbi();

$query2 = $dbh->prepare ( 'INSERT into link_key (link_id,keyword,key_cnt) VALUES(?,?,?)') || die $query2->errstr;
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
 ($keyword,$page_id,$cnt) = split (/\t/,$_);
 #if ($keyword eq '.net'){ $keyword = " .net";}
#my ($site,$linkid) = split (/-/,$page_id);
#print "$page_id\t$keyword\t$cnt\n";
$query2->execute($page_id,$keyword,$cnt);
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




 
