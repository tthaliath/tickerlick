#!/usr/bin/perl
my @arr = ('2018-03-08','2018-03-09','2018-03-12','2018-03-13','2018-03-14','2018-03-15','2018-03-16','2018-03-19','2018-03-20','2018-03-21','2018-03-22','2018-03-23');
foreach $d1 (sort @arr)
{
   #print "$d1\n";
   system("/home/tthaliath/tickerlick/daily/loadprice.sh $d1"); 
}
