#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: in01_getclipperfiles.pl
#Date started : 02/10/04    
#Last Modified : 02/10/04
#Purpose : Read clipper files in clipper folder , pass it to index program 
#--------------------------------------------------------------------------
#Modification History bnmj n
#Date : 
#	
#-------------------------------------------------------------------------
use strict ;

my $data_dir = "clipper/" ;
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
 #print "$i\t$filename\n";
 system("perl in02_indexwords.pl $filename");
 #if ($i > 9){last;}
 

 }
close (IN);


exit 1;
