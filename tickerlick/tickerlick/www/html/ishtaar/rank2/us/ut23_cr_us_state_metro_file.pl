#!c:/perl/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath
#Program File: ut23_cr_us_state_metro_file.pl
#Date started : 09/16/04
#Last Modified : 09/16/04
#--------------------------------------------------------------------------
#Modification History
#-------------------------------------------------------------------------
use strict ;

my (%lochash,$location,$state,$metro);
my ($i) = 100;
open (F,"us_metros_com_list_all.txt");
while (<F>)
{
chomp;
($state,$metro)= split(/\t/,$_);
$state =lc ($state);
$metro = lc ($metro);
$lochash{$state}{$metro}++;
}
	
close(F);
open (OUT,">us_state_metro_master.txt");
foreach $state(sort keys (%lochash))
{
  my (%statehash) = %{$lochash{$state}};
  foreach $location (keys (%statehash))
  {
    $i++;
     print OUT "$i\t$state\t$location\n";
 }
} 
close (OUT);
print "total $i - 100 loactions\n";
1;
