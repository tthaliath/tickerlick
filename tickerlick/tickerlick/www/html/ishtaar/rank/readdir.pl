#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: readdir.pl
#Date started : 10/05/03
#Last Modified : 10/05/03
#Purpose : Read files from data folder, pass it to the clipper program
#--------------------------------------------------------------------------
#Modification History 
#Date : 
#	
#-------------------------------------------------------------------------
use strict ;


my $clipper_dir = "d:/ishtaar/rank/clipper/" ;
my $data_dir = "d:/ishtaar/rank/data/" ;
my $fullname;
my $file;
my ($in,$header,$cr_date,$cr_time,$filesize);
my @sub_list;

my $i = 0;
my ($key);
open (F,"dir data /od|");

while (<F>)
{
  chomp;
 ($cr_date,$cr_time,$filesize,$file) = split (/\s+/,$_);
  if ($cr_date =~ /10\/15\/2003|10\/17\/2003/){
    if ($file =~ /\.txt/ && $file !~ /ibhar\.txt|blueshift\.txt/){push (@sub_list,$file);}
    
  }
}
close (F);
my $filename;
foreach $filename(@sub_list)
{
$i++;
 #if (-e "$clipper_dir/$filename"){print "$i $filename exists\n";next;}
 print "$i\t$filename\n";
 #if ($i > 535){
 system("perl clipper.pl $filename");
 #}
 #if ($i > 9){last;}
 

 }



exit 1;
