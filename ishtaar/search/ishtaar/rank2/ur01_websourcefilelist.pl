#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: ur01_websourcefilelist.pl
#Date started : 01/01/04
#Last Modified : 01/01/04
#Purpose :  Read the file names in the web source directory, pass it to  program  to
#exapnd the URL
#--------------------------------------------------------------------------
#Modification History 
#Date : 
#	
#-------------------------------------------------------------------------
use strict ;


my $link_dir = "websrc1/" ;
my $data_dir = "websrc2/" ;
my $fullname;
my $file;
my ($in,$header);
my @sub_list;

my $i = 0;
my ($key);

opendir (DIR, $link_dir) ;
while (defined($file = readdir(DIR))){
  if ($file =~ /^mphasis\.txt/) {
    push (@sub_list,$file);
    
  }
}
closedir (DIR);
my $filename;
foreach $filename(@sub_list)
{
$i++;
 #if (-e "$data_dir/$filename"){print "$i $filename exists\n";next;}
 #print "$i\t$filename\n";
 #if ($i == 1722 || $i == 1206 || $i == 1127 || $i == 1287 || $i == 68){
 system("perl ur02_convert2absurl.pl $filename");
 #}
 #if ($i > 9){last;}
 

 }
close (IN);


exit 1;
