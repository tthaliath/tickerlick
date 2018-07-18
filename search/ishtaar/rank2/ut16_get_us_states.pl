#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: ut16_getus_states.pl
#Date started : 
#Last Modified : 10/12/04

use strict;
my ($state);
open (ORIG,">us_states.txt");
open (IN,"us_states_html.txt");
while (<IN>){
  chomp;
  if (/.*?href.*?><b>(.*?)<\/b>.*/i){
      $state = $1;
      $state =~ s/ /_/g;
      $state =~ s/\,|\(|\)|\./_/g;
      print ORIG "$state\n";
    }
   
}
close (F);
close (ORIG);
1;
