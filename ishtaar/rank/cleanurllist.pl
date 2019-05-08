#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: cleanurllist.pl
#Date started : 09/21/03
#Last Modified : 09/21/03
#Purpose : read the url list and remove unwanted URL'S.

use strict;
my ($id,$site,$desc,$cnt,$loc);
open (F,"com_rel_data1.txt");
my %stop;
while (<F>){

 chomp;
 ($id,$site,$desc,$cnt) = split (/\t/,$_);

 if (!$cnt){
  if ($cnt == 0){
   print "$id\n";
   $stop{$id}++;   
}
 }
}
close (F);
open (F,"siteall.txt");
open (OUT,">siteallnew.txt");

while (<F>){

 chomp;
($id,$site,$loc,$desc) = split (/\t/,$_);
if($stop{$id}){next;}
print OUT "$_\n";
}
close(F);
close(OUT);
exit 1;