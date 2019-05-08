#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File : ut08_addcitycode.pl
#Date started : 
#Last Modified : 10/12/03

use strict;
my ($code) = 700;
open (OUT,">country_city_code.txt");
open (F,"country_city.txt");
while (<F>)
{
   chomp;
   $code++;
   my ($ccode,$country,$city) = split (/\t/,$_);
   print OUT "$ccode\t$country\t$city\t$code\n";
}
close (F);
close (OUT);
1;
