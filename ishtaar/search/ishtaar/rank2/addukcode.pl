#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File : ut07_getusregions.pl
#Date started : 
#Last Modified : 10/12/03
my $code = 500;
use strict;
open (OUT,">uk_code.txt");
open (F,"citylist_uk.txt");
while (<F>)
{
   chomp;
   $code++;
   my ($country,$city) = split (/\t/,$_);
   print OUT "gb\t$country\t$city\t$code\n";
}
close (F);
close (OUT);
1;
