#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: ut18_getus_regions_business.pl 
#Date started : 09/16/04
#Last Modified : 09/16/04
#--------------------------------------------------------------------------
#Modification History 
#-------------------------------------------------------------------------
use strict ;
use LWP::Simple; 

my ($base_link1,$full_url,$newdescorig,$base_link2,$numid,$text);
my ($i,$country,%crawled,$city,%orig,$base_link2,$base_link3);
my ($i) = 0;
$base_link1 = "http://dir.yahoo.com/Regional/U_S__States/";
#$base_link2 = "/States_and_Territories/";
#$base_link2 = "/Cities/";
#$base_link2 = "/Cities_and_Towns/";
#$base_link2 = "/Cities_and_Provinces/";
#$base_link2 = "/Provinces_and_Districts/";
#$base_link2 = "/Cities_and_Regions/";
$base_link2 = "/Counties_and_Regions/";
$base_link3 = "/Business_and_Shopping/Business_to_Business/";
open (CRAWLED1,"<us_counties.txt");
while (<CRAWLED1>){chomp; $crawled{$_}++;}
close (CRAWLED1);
open (NOCITY,">nobusiness.txt");
open (F,"us_regions.txt");
open (CRAWLED,">us_counties.txt");
while (<F>)
{
chomp;
my ($state,$county)= split (/\t/,$_);
$full_url = $base_link1.$state.$base_link2.$county.$base_link3;
if ($crawled{$full_url}){next;}
$i++;
$text = get $full_url;
#print "$full_url\n";
if ($text){
print CRAWLED "$full_url\n";
}
else{print NOCITY "$state\t$county\n";} 
#last;
}
close(F);
close(NOCITY);
close(CRAWLED);
exit 1;
