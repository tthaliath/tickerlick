#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: ut22_get_us_metros_business_cat2.pl 
#Date started : 09/16/04
#Last Modified : 09/16/04
#--------------------------------------------------------------------------
#Modification History 
#-------------------------------------------------------------------------
use strict ;
use LWP::Simple; 

my ($base_link1,$full_url,$newdescorig,$base_link2,$numid,$text);
my ($i,$cat,$state,$metro,%crawled,$city,%orig,$busi,$busi2,$base_link2,$base_link3,$base_link4);
my ($i) = 0;
my ($curl,$cname,$cloc,$flag);
$base_link1 = "http://dir.yahoo.com/Regional/U_S__States/";
#$base_link2 = "/States_and_Territories/";
#$base_link2 = "/Cities/";
#$base_link2 = "/Cities_and_Towns/";
#$base_link2 = "/Cities_and_Provinces/";
#$base_link2 = "/Provinces_and_Districts/";
#$base_link2 = "/Cities_and_Regions/";
$base_link2 = "/Metropolitan_Areas/";
$base_link3 = "/Business_and_Shopping/Business_to_Business/";
#my ($pat) = "Communications and Media Services|Communications and Networking|Computers|Consulting|Electronic Commerce|Electronics|Imaging|Security|Software";
open (CRAWLED1,"<us_metros_busi_cat2.txt");
while (<CRAWLED1>){chomp; $crawled{$_}++;}
close (CRAWLED1);
open (NOCITY,">nometros_busi_cat2.txt");
open (F,"us_metros_cat_list.txt");
while (<F>)
{
chomp;
my ($state,$metro,$busi,$busi2)= split (/\t/,$_);
#print "$state\n";

$full_url = $base_link1.$state.$base_link2.$metro.$base_link3.$busi."/".$busi2;
if ($crawled{$full_url}){next;}

$text = get $full_url;
#print "$full_url\n\n";
if (!$text){print NOCITY "$state\t$metro\t$busi\t$busi2\n";next}
$i++;
#$text =~ s/\n/ /g;
#$text =~ s/\s+/ /g;
open (OUT,">>us_metros_cat_list2.txt");
if ($text =~ /.*?CATEGORIES(.*?)<\/table>/sgi){
 
 #print "CATEGORY:$1\n\n";
  my ($text1) = $1;
  while ($text1 =~ /.*?href.*?<b>(.*?)<\/b>/sgi){
     #print "$1\n";
     $cat = $1;
     $cat =~ s/\@//g;
     $cat =~ s/ /_/g;
     $cat =~ s/\,|\(|\)|\.|\/|\\/_/g;
     print OUT "$state\t$metro\t$busi\t$busi2\t$cat\n";
    }
}
close(OUT);

open (OUT1,">>us_metros_com_list2.txt");
if ($text =~ /.*?SITE LISTINGS(.*?)<\/table>/sgi){
 #print "SITELISTING:$1\n\n";
  my ($text2) = $1;
  while ($text2 =~ /.*?<li.*?href.*?\*(.*?)\">(.*?)<\/a>.*?<i>(.*?)<\/i>/sgi){
     #print "$1\n";
     $curl = $1;
     $cname = $2;
     $cloc = $3;
     $curl =~ s/\%3A/\:/gi;
     print OUT1 "$state\t$metro\t$busi\t$busi2\t$cname\t$curl\t$cloc\n";
    }
}
close(OUT1);

open (CRAWLED,">>us_metros_busi_cat2.txt");
print CRAWLED "$full_url\n";
close (CRAWLED); 
#if ($i > 50){last;}
#last;
}
close(F);
close(NOCITY);
print "$i processed\n";
exit 1;
