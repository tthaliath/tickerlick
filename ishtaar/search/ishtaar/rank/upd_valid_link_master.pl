#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: upd_valid_link_master.pl
#Date started : 10/18/03
#Last Modified : 10/18/03
#desc: update valid_link_master table

use strict;

use DBI;  # Here's how to include the DBI module 



my ($dbh,$link_id,$url,$link_text,$page_title,$page_type,$query);  
#my(%ptext,%ptitle,%purl);
my ($i) = 0;
$dbh = open_dbi();
open (IFH, "<validlinksmaster.txt") or die ("Could not open input file.");
$query = $dbh->prepare ( 'INSERT into valid_link_master (link_id,url,link_text,page_title,page_type) VALUES(?,?,?,?,?)') || die $query->errstr;
while (<IFH>) {
chomp;
($link_id,$url,$link_text,$page_title,$page_type) = split /\t/, $_;
 $page_title =~ s/\&nbsp\;//gi;
 $link_text =~ s/\&nbsp\;//gi;
if (length($url) > 255){$i++;print "$link_id\t$url\n";}
if (length($link_text) > 255){$i++;print "$link_id\t$link_text\n";}
if (length($page_title) > 255){$i++;print "$link_id\t$page_title\n";}
$query->execute($link_id,$url,$link_text,$page_title,$page_type);
}   
close IFH;
#$dbh->commit();
$dbh->disconnect();
sub open_dbi
{
   # Declare and initialize variables
   my $host = 'localhost';
   my $db = 'ishtaar';
   my $db_user = 'thaliath';
   my $db_password = '69dimple';

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

