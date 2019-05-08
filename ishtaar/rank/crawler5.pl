#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: crawler5.pl
#Date started : 10/09/03
#Last Modified : 10/09/03
#Purpose : Read daTA files in data folder , pass it to index proram 
#--------------------------------------------------------------------------
#Modification History 
#Date : 
#	
#-------------------------------------------------------------------------
use strict ;

my $data_dir = "d:/ishtaar/rank/clipper/" ;
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
 print "$i\t$filename\n";
 system("perl indexkeywords.pl $filename");
 #if ($i > 0){last;}
 

 }
close (IN);


exit 1;
