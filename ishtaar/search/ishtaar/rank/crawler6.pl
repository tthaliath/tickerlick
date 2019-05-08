#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: crawler6.pl
#Date started : 10/09/03
#Last Modified : 10/09/03
#Purpose : Read daTA files in index folder , pass it to index program 
#--------------------------------------------------------------------------
#Modification History 
#Date : 
#	
#-------------------------------------------------------------------------
use strict ;

my $data_dir = "d:/ishtaar/rank/index/" ;
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
 system("perl indexbypage.pl $filename");
 #if ($i > 0){last;}
 

 }
close (IN);


exit 1;
