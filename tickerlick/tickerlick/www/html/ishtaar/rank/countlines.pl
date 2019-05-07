#!c:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: countlines.pl
#Date started : 05/31/03
#Last Modified : 10/02/03
#Purpose : get a list of files in a directory of fewer than 10 lines
#--------------------------------------------------------------------------
#Modification History 
#Date : 
#	
#-------------------------------------------------------------------------
use strict ;


my $data_dir = "d:/ishtaar/rank/data" ;
my $fullname;
my $file;
my $id;
my $header;
my @sub_list;
my %subcounts = ();
my %aa;
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
my $flag,$header;
open (OUT,">sitererun.txt");
foreach $filename(@sub_list)
{
 $i = 0;
 $flag = 0;
 $fullname = "$data_dir/$filename";
 open(IN,"$fullname");
 while (<IN>)
 {
  chomp;
  $i++;
  if (!$flag)
  {
    $header = $_;
    $flag = 1;
   }
  if ($i > 9){last;}
 }
close (IN);
if ($i < 10)
{
  $header =~ /(^\d+?)-(.*)/;
  $id = $1;
   print OUT "$id\t$header\n"; 
}
}
close (OUT);
exit 1;
