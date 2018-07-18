#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: ut17_get_us_regions.pl 
#Date started : 10/13/04
#Last Modified : 10/13/04
#Purpose : Fetch the web page for the given us state and get the regions 
#--------------------------------------------------------------------------
#Modification History 
#-------------------------------------------------------------------------
use strict ;
use LWP::Simple; 

my ($base_link1,$full_url,$newdescorig,$base_link2,$numid,$text);
my ($i,$state,$county,%orig);
my ($i) = 0;
$base_link1 = "http://dir.yahoo.com/Regional/U_S__States/";
#$base_link2 = "/States_and_Territories/";
#$base_link2 = "/Cities/";
#$base_link2 = "/Cities_and_Towns/";
#$base_link2 = "/Cities_and_Provinces/";
#$base_link2 = "/Provinces_and_Districts/";
#$base_link2 = "/Cities_and_Regions/";
$base_link2 = "/Counties_and_Regions/";
open (NOCITY,">nocounty.txt");
open (F,"us_states.txt");
while (<F>)
{
chomp;
$state = $_;
$full_url = $base_link1.$state.$base_link2;
print "$state\n";
$i++;
$text = get $full_url;
#print "$text\n";
if ($text)
{
open (OUT,">>us_regions.txt");
if ($text =~ /.*?CATEGORIES(.*?)<\/table>/sgi){
 # print "TEXT:$text\n";  
  $text = $1;
  while ($text =~ /.*?href.*?<b>(.*?)<\/b>/sgi){
     $county = $1;
     $county =~ s/\@//g;
     $county =~ s/ /_/g;
     $county =~ s/\,|\(|\)|\./_/g;
     print OUT "$state\t$county\n";
    }
}
close(OUT);
}
else{print NOCITY "$state\n";} 
}
close(F);
close(NOCITY);
exit 1;
