#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: ut02_getcountrycodes.pl
#Date started : 
#Last Modified : 10/12/03

use strict;
my ($country,$orig_country,$country_code);
open (ORIG,">country_code.txt");
open (IN,"countrycode.txt");
while (<IN>){
  chomp;
  if(/<option value=\"(.*?)\">(.*?)<\/option>/i){
      $country_code = $1;
      $country = $2;
      print ORIG "$country_code\t$country\n";
    }
  else{ print "$_\n";}
   
}
close (IN);
close (ORIG);
1;
