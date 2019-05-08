#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: findinvalidtype.pl
#Date started : 10/05/03
#Last Modified : 10/05/03
#Purpose : Read the contents of a text file, get the content type of eaCH url.

use strict;
my %aa;
#my ($id,$category,@keylist,$keystr,$pat,$value);
my ($filename,$key);
my $data_dir = "d:/ishtaar/rank/clipper/" ;
my $fullname;
my $file;
my ($in,$header,$link);
my @sub_list;

my $i = 0;
my ($key);
open (OUT,">invalidtype.txt");
opendir (DIR, $data_dir) ;
while (defined($file = readdir(DIR))){
  if ($file =~ /\.txt/) {
    push (@sub_list,$file);
    
  }
}
closedir (DIR);
foreach $filename(@sub_list)
{
$i++;
$fullname = $data_dir.$filename;
print "$i\t$fullname\n";
undef $/;
open (F,"<$fullname");
my $texthtml = <F>;
$/ = "\n";
close(F);
while ($texthtml =~ /.*?http:\/\/.*\.(.*?)\n.*?\n\n/mgi){


   $link = $1;
   if ($link =~ /\?/){$link =~ s/(.*?)\?/\1/g;}
   $aa{$1}++;

}
close(F);
}

foreach $key(sort keys(%aa)){print OUT "$key\n";}
close(OUT);
exit 1;


