#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: indexnew.pl
#Date started : 02/14/04
#Last Modified : 02/14/04
#Purpose : Read the contents of an index file, create nextword index


use strict;
use DB_File;
my ($keyword,$key);
my ($page_id,$cnt);
my ($total,$links,%keyhash,$k,$rem,$text);
my ($id,$category,$keystr,$clink,$texthtml,$dest_file);
my $data_dir = "d:/ishtaar/rank2/clipper/" ;
my $fullname;
my $file;
my ($pat,$catid);
my @sub_list;
my (%termhash,$termfirst,$termnext,$termlist);
open (IN,"indexmaster.txt");

while (<IN>){
  chomp;
  ($keystr) = split(/\t/,$_);
  $termhash{$keystr};
}
close (IN);
my $i = 0;
opendir (DIR, $data_dir) ;
while (defined($file = readdir(DIR))){
  if ($file =~ /\.txt/) {
    push (@sub_list,$file);
    
  }
}
closedir (DIR);
my $filename;
$k = 0;
foreach $term (sort keys(%termhash))
{
foreach $filename(@sub_list)
{
 $i++;
 print "$i\t$filename\n";
 $fullname = $data_dir.$filename;
 
 undef $/;
 open (F,"<$fullname");
 $text = <F>;
 close(F);
 $/ = "\n";



 
   while ($text =~ /(.*)?\thttp:\/\/.*?\n(.*?)\n\n/mgi)
   {
   $clink = $1;
   #print "$clink\n";
   $texthtml = $2;
   $texthtml =~ s/mr\.|ms\.|mrs\.|dr\./ /gi;
   %keyhash = ();
   
   while ($texthtml =~ /\b$term\s(.*)?\s/gis){
    #print "$clink\t$1\n"; 
    $keyhash{$termnext}++;
    }
   }
   }
   
   $termlist = '';
   $i = 0;
    foreach $termnext(sort (%keyhash{$b} <=> %keyhash{$a}) keys %keyhash)
    {
      $i++;
      $termlist .= $termnext.',';
      
    if ($i > 9)
    {
     last;
    }
   
  }
  $termlist =~ s/^(.*)\,/$1/g;
  $termnexthash{$term} = $termlist;

}



}


                           
exit 1;


