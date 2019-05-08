#!c:/perl/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath
#Program File: ut25_cr_us_location_master.pl
#Date started : 09/16/04
#Last Modified : 09/16/04
#--------------------------------------------------------------------------
#Modification History
#-------------------------------------------------------------------------
use strict ;

my (%lochash,$location,$key,$domain_name,$rest,$domain,$cid);
my ($locid,$cat2,$statcode,$state,$metro,$metrodesc,$cat1,$cname,$url,$loc,$curl);
my ($i) = 2000;

open (F,"us_location_master.txt");
while (<F>)
{
chomp;
($cid,$locid,$metrodesc,$cname,$curl,$loc,$domain_name)= split(/\t/,$_);
if ($lochash{$domain_name}){print "$_\n";next;}
$lochash{$domain_name}++;
}

close(F);


