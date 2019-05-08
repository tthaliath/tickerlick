#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: in06_buildmainindexbykey.pl
#Date started : 02/14/04
#Last Modified : 02/14/04
#Purpose : Read the contents of an index file, create nextword index


use strict;
#use DB_File;
my ($keyword,$key);
my ($page_id,$cnt);
my ($total,$links,%keyhash,$k,$rem,$text,$fileid);
my ($id,$category,$keystr,$clink,$texthtml,$pos,$tmp);
my $data_dir = "index/" ;
my $fullname;
my $file;

my @sub_list;
my $spec_chars = '\#|\`|\~|\!|\$|\%|\^|\&|\*|\+|\?|\[|\]|\{|\}|\*|\"|\'|\(|\)|\:|<|>|\-|\_|\[|\]|\\|\/';


system("rm termmastermainbykey.txt");


my $i = 0;
opendir (DIR, $data_dir) ;
while (defined($file = readdir(DIR))){
  if ($file =~ /\.txt/) {
     #print "$file\n";
    push (@sub_list,$file);
    
  }
}
closedir (DIR);
my $filename;

open (OUT,">termmastermainbykey.txt");

%keyhash = ();
foreach $filename(@sub_list)
{
 
 $i++;
 #print "$i\t$filename\n";
 $fullname = $data_dir.$filename;
 
 
 open (F,"<$fullname");
 
 
   while (<F>)
      {
        chomp;
        ($keyword,$fileid,$tmp,$cnt,$pos) = split(/\t/,$_);
         if ($keyword =~ /^[a-z|0-9|$spec_chars]+$/){
          if ($keyhash{$keyword})
          {
             $keyhash{$keyword} .= 'k'.$fileid.'_'.$pos;
          }
          else
   
           {
       
             $keyhash{$keyword} = $fileid.'_'.$pos;
           }
         }
        }
        close(F);
        
   }
        foreach $keyword(keys(%keyhash))
       {print OUT "$keyword\t$keyhash{$keyword}\n";}


print "$i\n";
exit 1;


