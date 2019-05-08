#!/usr/bin/perl
$str1 = 'var india=new Array("------------------ Select all -------------------"';
$str2 = 'var indiaId=new Array(0';
open (F,"<city_loc_in.txt");
while(<F>){
chomp;
($id,$city) = split (/\t/,$_);
$city = '"'.$city.'"';
$str1 .= ",".$city;
$str2 .= ",".$id;	
}
close (	F);
print "$str1\n$str2\n";
1;
