#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: crawler4.pl
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
my ($in,$header);
my @sub_list;

my $i = 0;
my ($key);

opendir (DIR, $data_dir) ;
while (defined($file = readdir(DIR))){
  if ($file =~ /^dgipro-automation\.txt/) {
    push (@sub_list,$file);
    
  }
}
closedir (DIR);
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
close (IN);


exit 1;
