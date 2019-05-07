#!/usr/bin/perl
open (F ,"us_state_metro_master.txt");
while (<F>){
chomp;
($a,$b,$c) = split(/\t/,$_);
 if ($d{$c}){print "$d{$c}\n$_\n\n";next;}
 $d{$c} = "$a\t$b";

}
close (F);
1; 
