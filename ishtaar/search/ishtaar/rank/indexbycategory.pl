#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: indexcategory.pl
#Date started : 10/12/03
#Last Modified : 10/12/03
#Purpose : Read the contents of a text file, index  categories

use strict;
use DB_File;
my ($keyword,$key);
my ($page_id,$cnt);
my ($total,$links,%keyhash,$k,$rem,$text);
my ($id,$category,$keystr,$clink,$texthtml,$dest_file);
my $data_dir = "clipper/" ;
my $index_dir = "indexcat/" ;
my $fullname;
my $file;
my ($pat,$catid);
my @sub_list;
my (%cathash,%catidhash);
open (IN,"categorymaster.txt");
while (<IN>){
  chomp;
  ($id,$category,$keystr) = split(/\t/,$_);
  $cathash{$id} = $keystr;
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
foreach $filename(@sub_list)
{
 $i++;
 #print "$i\t$filename\n";
 $fullname = $data_dir.$filename;
 $dest_file = $index_dir.$filename;
 undef $/;
 open (F,"<$fullname");
 $text = <F>;
 close(F);
 $/ = "\n";
 open(OUT,">$dest_file");


 
   while ($text =~ /^(\d+-\d+)\thttp:\/\/.*?\n(.*?)\n\n/mgi)
   {
   $clink = $1;
   #print "$clink\n";
   $texthtml = $2;
  $texthtml =~ s/mr\.|ms\.|mrs\.|dr\./ /gi;
   %keyhash = ();
   %catidhash = ();
   foreach $catid(keys (%cathash))
  {
   $pat = $cathash{$catid};
     #print "$pat\n";
   while ($texthtml =~ /\b($pat)\b/gis){
    #print "$clink\t$1\n"; 
    $keyhash{$1}++;
    $catidhash{$1} = $catid;}
   }
   foreach $key(keys %keyhash){
    if ($keyhash{$key} > 0)
    {
     #print "$catid\n";
     print OUT "$clink\t$key\t$catidhash{$key}\t$keyhash{$key}\n";
    }
   
  }

}


close (OUT);
}


                           
exit 1;

 
