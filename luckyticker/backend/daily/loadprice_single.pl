#!/usr/bin/perl
my @arr = ('2018-03-26');
foreach $d1 (sort @arr)
{
   #print "$d1\n";
   system("/home/tthaliath/tickerlick/daily/loadprice.sh $d1"); 
}
