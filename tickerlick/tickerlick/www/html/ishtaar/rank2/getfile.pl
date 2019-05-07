#!/usr/bin/perl

open (F,"2");
while(<F>){
chomp;
if ( -e linklist1/$_){next;}
print "$_\n";
}
close (	F);
