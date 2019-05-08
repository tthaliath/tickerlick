#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: st03_getwebtextfiles.pl
#Date started : 02/01/04
#Last Modified : 02/01/04
#Purpose : Read files from data folder, pass it to the clipper program
#--------------------------------------------------------------------------
#Modification History 
#Date : 
#	
#-------------------------------------------------------------------------
use strict ;


my $data_dir = "data3/" ;
my $clipper_dir = "clipper1/" ;
my $fullname;
my $file;
my ($in,$header);
my @sub_list;

my $i = 0;
my ($key);

opendir (DIR, $data_dir) ;
while (defined($file = readdir(DIR))){
  if ($file =~ /\.txt/) {
    push (@sub_list,$file);
    
  }
}
closedir (DIR);
my $filename;
foreach $filename(@sub_list)
{
$i++;
 if (-e "$clipper_dir/$filename"){next;}
# print "$i\t$filename\n";
 system("perl st04_clipper.pl $filename");
 #if ($i > 9){last;}
#last; 

 }
close (IN);


exit 1;
