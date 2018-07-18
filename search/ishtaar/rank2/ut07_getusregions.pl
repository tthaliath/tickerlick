#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File : ut07_getusregions.pl
#Date started : 
#Last Modified : 10/12/03

use strict;
my $code = 100;
undef $/;
open (F,"usregions.txt");
 my $text = <F>;
 close(F);
 $/ = "\n";
close (IN);
open (OUT,">us_code.txt");
my @regionarr = split (/\,/,$text);
foreach my $region(@regionarr)
{
   $region =~ s/\"//g;
   $code++; 
   print OUT "us\tUnited States\t$region\t$code\n";
}

close (OUT);
1;
