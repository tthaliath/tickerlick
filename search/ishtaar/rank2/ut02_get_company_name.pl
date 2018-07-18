#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: company_desc.pl
#Date started : 09/15/03
#Last Modified : 09/15/03
#Purpose : Read the master company file and get a meaningful description of the company.

use strict;

my($id,$url,$loc,$cdesc,$site,$newdesc,$size);
#Open file1
open (FILE1,"<site_master_all.txt");
open (FILE2,">newcompanydesc.txt");

my $stopword  = '\(p\)|ltd\.|limited|pvt\.|private';
while(<FILE1>)
{
 chomp;
 my ($str) = $_;
  $str =~ s/^M//gi;
 ($id,$url,$loc,$cdesc) = split(/\t/,$str);
 $url =~ /.*?\.(.*?)\.(.*)/;
 $site = $1;
 
   $newdesc = $cdesc;
   
$newdesc =~ s/\(p\)|ltd\.|limited|pvt\.|private|pvt|ltd|inc\.]//gi;
$newdesc =~ s/inc\.//gi;

#print "$newdesc\n";

print FILE2 "$id\t$url\t$cdesc\t$newdesc\n";




} # EOF WHILE LOOP
close(FILE1);
close(FILE2);
exit 1;
