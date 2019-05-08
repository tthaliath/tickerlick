#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: ut04_getcities.pl 
#Date started : 09/16/04
#Last Modified : 09/16/04
#Purpose : Fetch the web page for the given country and get the city names
#--------------------------------------------------------------------------
#Modification History 
#-------------------------------------------------------------------------
use strict ;
use LWP::Simple; 

my ($base_link1,$full_url,$newdescorig,$base_link2,$numid,$text);
my ($i,$country,%crawled,$city,%orig);
my ($i) = 0;
$base_link1 = "http://dir.yahoo.com/Regional/Countries/";
#$base_link2 = "/States_and_Territories/";
#$base_link2 = "/Cities/";
#$base_link2 = "/Cities_and_Towns/";
#$base_link2 = "/Cities_and_Provinces/";
#$base_link2 = "/Provinces_and_Districts/";
#$base_link2 = "/Cities_and_Regions/";
$base_link2 = "/Counties_and_Regions/";
open (ORIG,"<orig_country.txt");
while (<ORIG>){
chomp;
my ($a,$b) = split (/\t/,$_);
$orig{$a} = $b;
}
close (ORIG);
open (CRAWLED1,"<countries.txt");
while (<CRAWLED1>){chomp; $crawled{$_}++;}
close (CRAWLED1);
open (NOCITY,">nocity.txt");
open (F,"countrylist.txt");
while (<F>)
{
chomp;
$country = $_;
if ($crawled{$country}){next;}
$full_url = $base_link1.$country.$base_link2;
print "$country\n";
$i++;
$text = get $full_url;
#print "$text\n";
if ($text)
{
open (OUT,">>citylist_ie.txt");
if ($text =~ /.*?CATEGORIES(.*?)<\/table>/sgi){
 # print "TEXT:$text\n";  
  $text = $1;
  while ($text =~ /.*?href.*?<b>(.*?)<\/b>/sgi){
     $city = $1;
     $city =~ s/\@//g;
     print OUT "$orig{$country}\t$city\n";
    }
}
close(OUT);
open (CRAWLED,">>countries.txt");
print CRAWLED "$country\n";
close(CRAWLED);		
}
else{print NOCITY "$country\n";} 
#last;
}
close(F);
close(CRAWLED);
close(NOCITY);
exit 1;
