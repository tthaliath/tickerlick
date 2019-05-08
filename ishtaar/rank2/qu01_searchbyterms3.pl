#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: qu01_searchbyterms2.pl
#Date started : 03/06/04
#Last Modified : 03/06/04
#Purpose : select the links sort by rank for the given terms


use strict;
use DBI;
use DB_File;

my ($keyword,$key);
my ($page_id,$cnt);
my ($total,$links,%keyhash,$k,$rem,$text,$c,$d,$link,%hash,%sitehash);
my ($id,$query,$key_str,$dbh,$link_id_pos);
#Get the URL from command argument.
my ($terms) = 'java,';
$dbh = open_dbi();
$query= $dbh->prepare ('select key_str,link_id_pos from index_by_key where key_str in("logistics","oracle11i") and loc_id = 1' ) || die $query->errstr;
$query->execute();\
my (%linkcount,%linkhash,@linklist,%fileid,%siterankhash,$site_rank,%companyhash);
my $linkfilename = 'valid_links_dbfile.txt';
tie (%hash, 'DB_File', $linkfilename, O_RDWR, 0444, $DB_BTREE) || die $!;

#my $sitefilename = 'site_master_dbfile.txt';
#tie (%sitehash, 'DB_File', $sitefilename, O_RDWR, 0444, $DB_BTREE) || die $!;

while(($key_str,$link_id_pos)= $query->fetchrow_array())
{

   @linklist = []; 
   @linklist = split /k/, $link_id_pos;  
   #print "$key_str\n\n\n";
   foreach $key(@linklist){
   ($c,$d) = split(/_/,$key);
    ($site_rank,$link) = split(/j/,$c);
     #if ($keyhash{$key_str}{$c})
     #{ 
      # $keyhash{$key_str}{$c} .= ",".$d;}
     #else
    #$keyhash{$key_str}{$c} = $d;}
     #$fileid{$link}{$key_str}++;
     $fileid{$link}++;
     $siterankhash{$link} = sprintf("%5.2f",$site_rank);
     if ($link =~ /(.*?)\-.*/){
         $companyhash{$1} .= $link.'*';
         $linkcount{$1}++;}
                                                        
}

}
$query->finish;
$dbh->disconnect;  

#foreach $link (sort {$fileid{$b} <=> $fileid{$a} } keys %fileid){
#my %linkcnt = %{$fileid{$link}};
#foreach $cnt (keys %linkcnt){print "$cnt\t$linkcnt{$cnt}\n";}}
#print "$link\t$fileid{$link}\n";
#}
my (%linkhash,$clink,$firm,$j);
#foreach $link(sort { scalar keys %{$fileid{$b}} <=> scalar keys %{$fileid{$a}}|| $linkcount{$b} <=> $linkcount{$a} || $siterankhash{$b} <=> $siterankhash{$a} } keys (%companyhash))
#foreach $link(sort { scalar keys %{$fileid{$b}} <=> scalar keys %{$fileid{$a}}||$siterankhash{$b} <=> $siterankhash{$a} || $linkcount{$b} <=> $linkcount{$a}} keys (%companyhash))
foreach $firm(sort { $siterankhash{$b} <=> $siterankhash{$a} || $linkcount{$b} <=> $linkcount{$a}} keys (%companyhash))
{
  
%linkhash = {};  
 foreach $clink( split (/\*/,$companyhash{$firm}))
{
  $linkhash{$clink}++;
}
$j = 0;
foreach $link( sort {sortlinkbykeyword1($hash{$b}) <=> sortlinkbykeyword2($hash{$a}) || $fileid{$b} <=> $fileid{$a}} keys (%linkhash)){
#foreach $link( sort {$fileid{$b} <=> $fileid{$a}} keys (%linkhash)){
  $j++;
  if ($j < 6){
  print "$firm\t$fileid{$link}\t$link\t$siterankhash{$link}\n";
  print "$firm\t$fileid{$link}\t$hash{$link}\t$siterankhash{$link}\n";  
  }
  else{last;}
}
 
}  

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

sub sortlinkbykeyword1{
my $link = shift;
#print "tom1:$link\n";
if ($link =~ /product|service|solution|expert|industr/i)
{
  return 1;
}
else {return 0;}
}

sub sortlinkbykeyword2{
my $link = shift;
#print "tom2:$link\n";
if ($link =~ /product|service|solution|expert|industr/i)
{
  return 1;
}
else {return 0;}
}

                          
exit 1;


