#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: upd_site_master_filename.pl
#Date started : 10/18/03
#Last Modified : 10/19/03
#desc: update filename in site_master table

use strict;

use DBI;  # Here's how to include the DBI module 



my ($dbh,$link_id,$url,$link_text,$page_title,$page_type,$query);  
my($file,$firm,$cid);
my ($i) = 0;
$dbh = open_dbi();
open (IFH, "<sitemaster.txt") or die ("Could not open input file.");
$query = $dbh->prepare ( 'update site_master set filename = ? where site_id = ?') || die $query->errstr;
while (<IFH>) {
chomp;
($cid,$url) = split /\t/, $_;
$url=~s#^http://##gi;               # strip off http://
$url=~s/(.*)#.*/$1/;
$url=~s#^([^/]+).*#$1#;   # everything before first / is domain
$url =~ /.*?\.(.*?)\.(.*)/;
$firm = lc $1;
#print "$cid\t$firm\n";
$file  = $1.'.txt';
$query->execute($file,$cid);
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

