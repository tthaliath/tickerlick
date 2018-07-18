#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: in13_indexcategory.pl
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
my (%cathash,%catidhash,$fullpat,$key);
$fullpat = '';
open (IN,"categorymaster.txt");
while (<IN>){
  chomp;
  ($id,$category,$keystr) = split(/\t/,$_);
  if ($keystr =~ /\|/)
   {
     foreach $key(split(/\|/,$keystr)){
        if ($key =~ /\\/){$key =~ s/\\//g;}
        $cathash{$key} = $id;}
   }
  else
   {if ($keystr =~ /\\/){$keystr =~ s/\\//g;}
    $cathash{$keystr} = $id;}
  if ($fullpat){
  $fullpat .= "|".$keystr;
  }
  else{$fullpat = $keystr;}
}
close (IN);
#print "$fullpat\n";
#foreach $key(sort keys (%cathash)){print "$key:$cathash{$key}\n";}
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
  if (-e "$index_dir"."$filename"){next;}
 #print "$i\t$filename\n";
 $fullname = $data_dir.$filename;
 $dest_file = $index_dir.$filename;
 undef $/;
 open (F,"<$fullname");
 $text = <F>;
 close(F);
 $/ = "\n";


 
   while ($text =~ /^(\d+-\d+)\thttp:\/\/.*?\n(.*?)\n\n/mgi)
   {
   open(OUT,">>$dest_file");
   $clink = $1;
   #print "link:$clink\n";
   $texthtml = $2;
  $texthtml =~ s/mr\.|ms\.|mrs\.|dr\./ /gi;
   %keyhash = ();
   %catidhash = ();
   while ($texthtml =~ /\b($fullpat)\b/gis){
    $keyhash{$1}++;
    $catidhash{$1} = $cathash{$1};}
   foreach $key(keys %keyhash){
    if ($keyhash{$key} > 0)
    {
    # print "catid:$catid\n";
     print OUT "$clink\t$key\t$catidhash{$key}\t$keyhash{$key}\n";
    } 
  }
close(OUT);
}

}

print "DONE\n";
                           
exit 1;

 
