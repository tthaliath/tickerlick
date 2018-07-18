#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: cr08_crawler.pl
#Date started : 01/31/04
#Last Modified : 01/31/04
#Purpose : Read the URL from a text file , pass it to extractor program 
#--------------------------------------------------------------------------
#Modification History 
#Date : 
#	
#-------------------------------------------------------------------------
use strict ;


my $link_dir = "linklist2/" ;
my $web_dir = "websrc/" ;
my $data_dir = "websrc1/" ;
my $fullname;
my $file;
my ($in,$header);
my @sub_list;

my $i = 0;
my ($key);

opendir (DIR, $link_dir) ;
while (defined($file = readdir(DIR))){
  if ($file =~ /patni.txt/) {
    push (@sub_list,$file);
    
  }
}
closedir (DIR);
my $filename;
foreach $filename(@sub_list)
{
$i++;
 if (-e "$web_dir/$filename"){
 if (-e "$data_dir/$filename"){print "$i $filename exists in websrc1\n";next;}
 
 print "$i\t$filename\n";
 #if ($i == 1722 || $i == 1206 || $i == 1127 || $i == 1287 || $i == 68){
 system("perl cr09_getwebsource1.pl $filename");
 #}
 #if ($i > 9){last;}
 #last;
  }
  else
   {print "$i $filename does not exists in websrc\n";next;}
 }
close (IN);


exit 1;
