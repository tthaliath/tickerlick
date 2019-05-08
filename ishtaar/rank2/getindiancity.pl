#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File : ut07_getusregions.pl
#Date started : 
#Last Modified : 10/12/03

use strict;
open (OUT,">in_code.txt");
open (F,"locationweb.txt");
while (<F>)
{
   chomp;
   my ($code,$city) = split (/\t/,$_);
   print OUT "in\tIndia\t$city\t$code\n";
}
close (F);
close (OUT);
1;
