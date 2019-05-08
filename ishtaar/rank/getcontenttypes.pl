#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: getcontenttypes.pl
#Date started : 10/05/03
#Last Modified : 10/05/03
#Purpose : Read the contents of a text file, get the content type of eaCH url.

use strict;
my %aa;
#my ($id,$category,@keylist,$keystr,$pat,$value);
my ($filename,$key);
my $data_dir = "d:/ishtaar/rank/data/" ;
my $fullname;
my $file;
my ($in,$header);
my @sub_list;

my $i = 0;
my ($key);
open (OUT,">contenttype.txt");
opendir (DIR, $data_dir) ;
while (defined($file = readdir(DIR))){
  if ($file =~ /^ponl\.txt/) {
    push (@sub_list,$file);
    
  }
}
closedir (DIR);
foreach $filename(@sub_list)
{
$i++;
$fullname = $data_dir.$filename;
print "$i\t$fullname\n";

open (F,"<$fullname");

while (<F>){

if( /(.*?http:\/\/.*\.(.*))/i)
{
   print "$2\n";
   if ($1){$aa{$2}++;}
}
}
close(F);
}
close(OUT);
foreach $key(sort keys(%aa)){print "$key\n";}
exit 1;


