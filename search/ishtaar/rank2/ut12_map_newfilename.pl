#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File : ut12_map_newfilename.pl
#Date started : 
#Last Modified : 10/12/03

use strict;
open (OUT,">map_filename.txt");
open (F,"sitemaster.txt");
while (<F>)
{
   chomp;
   my ($a,$b,$c,$d,$e,$firm,$filename) = split (/\t/,$_);
   print OUT "$firm\t$filename\n";
}
close (F);
close (OUT);
1;
