#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: crawler3.pl
#Date started : 05/21/03
#Last Modified : 09/30/03
#Purpose : Read the URL from a text file , pass it to extractor program 
#--------------------------------------------------------------------------
#Modification History 
#Date : 
#	
#-------------------------------------------------------------------------
use strict ;


my $link_dir = "d:/ishtaar/rank/linklist2/" ;
my $data_dir = "d:/ishtaar/rank/data/" ;
my $fullname;
my $file;
my ($in,$header);
my @sub_list;

my $i = 0;
my ($key);

opendir (DIR, $link_dir) ;
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
 #if (-e "$data_dir/$filename"){print "$i $filename exists\n";next;}
 print "$i\t$filename\n";
 #if ($i == 1722 || $i == 1206 || $i == 1127 || $i == 1287 || $i == 68){
 system("perl preparedesc.pl $filename");
 #}
 #if ($i > 9){last;}
 

 }
close (IN);


exit 1;
