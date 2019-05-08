#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: getlocation.pl
#Date started : 10/15/03
#Last Modified : 10/15/03

use Strict;
open (F,"siteallnew.txt");
my (%hash);
while (<F>){
chomp;
my ($id,$url,$loc,$desc) = split (/\t/,$_);
$hash{$loc}++;
}
foreach (sort keys(%hash)){print "$_\n";}
close (F);
exit 1;