#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: st01_getcompanyfile.pl
#Date started : 01/31/04
#Last Modified : 01/31/04
#Purpose : Read files from data folder, pass it to the clipper program
#--------------------------------------------------------------------------
#Modification History 
#Date : 
#	
#-------------------------------------------------------------------------
use strict ;


my $data_dir = "websrc1/" ;
my $clipper_dir = "data/" ;
my $fullname;
my $file;
my ($in,$header);
my @sub_list;

my $i = 0;
my ($key);

opendir (DIR, $data_dir) ;
while (defined($file = readdir(DIR))){
  if ($file =~ /^iCMGworld\.txt/) {
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
 system("perl st02_webtext.pl $filename");
 #}
 #if ($i > 9){last;}
 

 }
close (IN);


exit 1;
