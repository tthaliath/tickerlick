#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: ut02_getcountries.pl
#Date started : 
#Last Modified : 10/12/03
#Purpose : Read the contents of a text file, index  categories

use strict;
my ($country,$orig_country);
open (ORIG,">orig_country.txt");
open (IN,"countries_html.txt");
while (<IN>){
  chomp;
  if (/.*?href.*?><b>(.*?)<\/b>.*/i){
      $country = $1;
      $orig_country = $country;
      $country =~ s/ /_/g;
      $country =~ s/\,|\(|\)/_/g;
      print ORIG "$country\t$orig_country\n";
    }
  else{ print "$_\n";}
   
}
close (F);
close (ORIG);
1;
