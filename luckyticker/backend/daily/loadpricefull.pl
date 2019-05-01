#!/usr/bin/perl
open (F,"/home/tthaliath/tickerlick/daily/tdates1");
while (<F>)
{
   $d1 = $_;
   if ($dl <= "2018-12-31")
    {
       system("/home/tthaliath/tickerlick/daily/loadprice.sh $d1"); 
    }
}
close (F);
