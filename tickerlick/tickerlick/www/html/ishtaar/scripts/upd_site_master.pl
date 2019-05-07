#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: upd_site_master.pl
#Date started : 10/18/03
#Last Modified : 10/19/03
#desc: update site_master table

use strict;

use DBI;  # Here's how to include the DBI module 



my ($dbh,$link_id,$url,$link_text,$page_title,$page_type,$query);  
my($a,$b,$c,$d,$e,$f);
my ($i) = 0;
$dbh = open_dbi();
open (IFH, "<sitemaster.txt") or die ("Could not open input file.");
$query = $dbh->prepare ( 'INSERT into site_master (site_id,site_url,site_loc_id,site_desc,site_rank,site_rank_log) VALUES(?,?,?,?,?,?)') || die $query->errstr;
while (<IFH>) {
chomp;
if(/^$/){next;}
($a,$b,$c,$d,$e,$f) = split /\t/, $_;
if (length($b) > 255){$i++;print "$a\t$b\n";}
if (length($d) > 255){$i++;print "$a\t$b\n";}
if (!$c){print "loc:$a\t$c\n";}
if (!$e){print "rank:$a\t$e\n";}
$query->execute($a,$b,$c,$d,$e,$f);
}   
close IFH;
#$dbh->commit();
$dbh->disconnect();
sub open_dbi
{
   # Declare and initialize variables
   my $host = 'localhost';
   my $db = 'ishtaar';
   my $db_user = 'istrtest';
   my $db_password = 'istrtest';

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

