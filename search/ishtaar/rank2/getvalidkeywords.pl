#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: getvalidkeywords.pl
#Date started : 02/14/04
#Last Modified : 02/14/04
#Purpose : Remove then unwanted terms


use strict;

my ($keystr,$i,$j);
my $spec_chars = '\#|\`|\~|\!|\$|\%|\^|\&|\*|\+|\?|\[|\]|\{|\}|\*|\"|\'|\(|\)|\:|<|>|\-|\_|\[|\]|\\|\/';
$i = 0;
$j = 0;
open (IN,"termmaster.txt");
open (OUT,">termmasternew.txt");
open (OUT1,">termmasterin.txt");
while (<IN>){
  chomp;
  ($keystr) = split(/\t/,$_);
  if ($keystr =~ /^[a-z|0-9|$spec_chars]+$/){
    $i++;print OUT "$_\n";}
  else
      { $j++;print OUT1 "$_\n";}
}
close (IN);
close (OUT);
close (OUT1);
print "$i\n";
print "$j\n";                          
exit 1;


