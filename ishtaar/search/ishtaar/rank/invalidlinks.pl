#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: invalidlinks.pl
#Date started : 10/12/03
#Last Modified : 10/12/03
#Purpose : Read the contents of a clipper file, get all the links whose content type is not text

use strict;

my $clipper_dir = "d:/ishtaar/rank/clipper/" ;
my $fullname;
my $file;
my ($in,$header);
my @sub_list;

my $i = 0;
my ($key);

opendir (DIR, $clipper_dir) ;
while (defined($file = readdir(DIR))){
  if ($file =~ /\.txt/) {
    push (@sub_list,$clipper_dir.$file);
    
  }
}
closedir (DIR);
my $filename;
open (FILE4,">invalidlinks.txt");
foreach $filename(@sub_list)
{
$i++;
 #if (-e "$clipper_dir/$filename"){print "$i $filename exists\n";next;}
 print "$i\t$filename\n";

open (F,"$filename");
undef $/;
my $texthtml = <F>;
close(F);
$/ = "\n";

my ($url,$special_char_pat,$text,$value);

while ($texthtml =~ /^(\d+-\d+\t(http:\/\/.*?))\n(.*?)\n\n/mgi)
{
   $value = $1;
   if ($value =~ /\.exe/i){print FILE4 "$value\n";next;}
    if ($value =~ /\.ico/i){print FILE4 "$value\n";next;}
    if ($value =~ /\.bmp/i){print FILE4 "$value\n";next;}
    if ($value =~ /\.ppt/i){print FILE4 "$value\n";next;} 
    if ($value =~ /\.pps/i){print FILE4 "$value\n";next;} 
    if ($value =~ /\.ram/i){print FILE4 "$value\n";next;} 
    if ($value =~ /\.mov/i){print FILE4 "$value\n";next;} 
    if ($value =~ /\.mp3/i){print FILE4 "$value\n";next;} 
    if ($value =~ /\.mpg/i){print FILE4 "$value\n";next;} 
    if ($value =~ /\.wot/i){print FILE4 "$value\n";next;} 
    if ($value =~ /\.tif/i){print FILE4 "$value\n";next;} 
    if ($value =~ /\.ps/i){print FILE4 "$value\n";next;} 
    if ($value =~ /\.jp/i){print FILE4 "$value\n";next;} 
    if ($value =~ /\.ru/i){print FILE4 "$value\n";next;} 
    if ($value =~ /\.rm/i){print FILE4 "$value\n";next;} 
    if ($value =~ /\.swf/i){print FILE4 "$value\n";next;} 
    if ($value =~ /\.doc/i){print FILE4 "$value\n";next;} 
    if ($value =~ /\.gz/i){print FILE4 "$value\n";next;} 
    if ($value =~ /\.gif/i){print FILE4 "$value\n";next;} 
   
 
}
}
close (OUT);
exit 1;