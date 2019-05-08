#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: ut02_getcountrycodes.pl
#Date started : 
#Last Modified : 10/12/03

use strict;
my (%ccode,$country,$city,$orig_country,$country_code);
open (IN,"country_code.txt");
while (<IN>){
chomp;
($country_code,$country) = split (/\t/,$_);
 $country =~ s/^\s(.*)/\1/g;
 $country =~ s/\s*$//;
 $country_code =~ s/\s*$//;
 $ccode{lc($country)}= lc($country_code);
   
}
close (IN);
open (OUT, ">>country_city.txt");
open (F,"<citylist_web1.txt");
while (<F>){
chomp;
($country,$city) = split (/\t/,$_);
 $country = lc($country); 
 $country =~ s/\s*$//g;
 $city =~ s/\s*$//; 
 if ($ccode{$country} )
{
   $country_code = $ccode{$country};
   $city =~ s/(\w+)/\u\L$1/g;
   $country =~ s/(\w+)/\u\L$1/g;
   print OUT "$country_code\t$country\t$city\n";
  }
else {print "$country\n";}
}
close (F);
close (OUT);
1;
