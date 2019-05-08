#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: category_master_web2.pl
#Date started : 10/21/03
#Last Modified : 10/21/03
#desc: update category master table

use strict;

use DBI;  

my($cat_str,$val,@catarr,$cat_id,$cat_desc,$parent_id,$level,$cat_id_add,$disp_flag,%cathash,$k,$i);
$k = 0;
open (F, "category_master_web2.txt") or die ("Could not open input file.");
while (<F>) {
chomp;
($cat_id,$cat_desc,$parent_id,$level,$cat_id_add,$disp_flag) = split (/\t/, $_);
$k++;
$cathash{$cat_id} = $cat_desc;
}   
close F;

open (F, "category_master_web2.txt") or die ("Could not open input file.");
open (OUT,">category_master_web5.txt") or die ("Could not open input file.");
while (<F>) {
chomp;
($cat_id,$cat_desc,$parent_id,$level,$cat_id_add,$disp_flag) = split (/\t/, $_);
$cat_str = $cat_id; 
if ($cat_id_add){
$i++;
print "$i:$cat_id\t$cat_id_add\n";
   if ($cat_id_add =~ /\,/){
      foreach $val (split (/\,/,$cat_id_add)){
           print "$cat_id\t$val\t$cat_str\n";
           $cat_str .= ",".$val;}
   }
  else { $cat_str .=",".$cat_id_add;}
}
  print OUT "$cat_id\t$cat_desc\t$parent_id\t$level\t$cat_str\t$disp_flag\n";
}
close F;
close OUT;
print "Total $k categories\n";
print "Total $i special categories\n";
exit 1;
