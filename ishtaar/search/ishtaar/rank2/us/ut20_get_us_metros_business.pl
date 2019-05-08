#!c:/perl/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: ut18_getus_metros_business.pl 
#Date started : 09/16/04
#Last Modified : 09/16/04
#--------------------------------------------------------------------------
#Modification History 
#-------------------------------------------------------------------------
use strict ;
use LWP::Simple; 

my ($base_link1,$full_url,$newdescorig,$base_link2,$numid,$text);
my ($i,$state,$metro,%crawled,$city,%orig,$busi,$base_link2,$base_link3);
my ($i) = 0;
$base_link1 = "http://dir.yahoo.com/Regional/U_S__States/";
#$base_link2 = "/States_and_Territories/";
#$base_link2 = "/Cities/";
#$base_link2 = "/Cities_and_Towns/";
#$base_link2 = "/Cities_and_Provinces/";
#$base_link2 = "/Provinces_and_Districts/";
#$base_link2 = "/Cities_and_Regions/";
$base_link2 = "/Metropolitan_Areas/";
$base_link3 = "/Business_and_Shopping/Business_to_Business/";
my ($pat) = "Communications and Media Services|Communications and Networking|Computers|Consulting|Electronic Commerce|Electronics|Imaging|Security|Software";
open (CRAWLED1,"<us_metros_busi.txt");
while (<CRAWLED1>){chomp; $crawled{$_}++;}
close (CRAWLED1);
open (NOCITY,">nometros_busi.txt");
open (F,"us_metro_list.txt");
while (<F>)
{
chomp;
my ($state,$metro)= split (/\t/,$_);
#print "$state\n";
$full_url = $base_link1.$state.$base_link2.$metro.$base_link3;
if ($crawled{$full_url}){next;}
$i++;
$text = get $full_url;
#print "$text\n";
open (OUT,">>us_metros_busi_list.txt");
if ($text =~ /.*?CATEGORIES(.*?)<\/table>/sgi){
 #print "TEXT:$text\n";
  $text = $1;
  while ($text =~ /.*?href.*?<b>(.*?)<\/b>/sgi){
     #print "$1\n";
     $busi = $1;
     $busi =~ s/\@//g;
     if ($busi =~ /$pat/i){
      $busi =~ s/ /_/g;
      $busi =~ s/\,|\(|\)|\.|\/|\\/_/g;
      print OUT "$state\t$metro\t$busi\n";
    }
}
close(OUT);

open (CRAWLED,">>us_metros_busi.txt");
print CRAWLED "$full_url\n";
close (CRAWLED);
}
else{print NOCITY "$state\t$metro\n";} 
#last;
}
close(F);
close(NOCITY);
print "$i processed\n";
exit 1;
