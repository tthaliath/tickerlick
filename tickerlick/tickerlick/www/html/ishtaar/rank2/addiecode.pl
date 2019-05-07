#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File : ut07_getusregions.pl
#Date started : 
#Last Modified : 10/12/03
my $code = 600;
use strict;
open (OUT,">ie_code.txt");
open (F,"citylist_ie.txt");
while (<F>)
{
   chomp;
   $code++;
   my ($country,$city) = split (/\t/,$_);
   print OUT "ie\t$country\t$city\t$code\n";
}
close (F);
close (OUT);
1;
