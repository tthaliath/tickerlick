#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File:in34_cr_link_data_dbfile.pl
#Date started : 10/12/03
#Last Modified : 10/15/03
#Purpose : Read the contents of files from clipper folder, get all the links and# validate against
#            linkmasterdbfile.txt, create validlinksmaster.txt

use strict;
use DB_File;

my $clipper_dir = "data3/" ;
my $fullname;
my $file;
my ($in,$header,%hash,%hash1,$fileid);
my @sub_list;

my $i = 0;
my ($key);
system ("rm link_data_dbfile.txt");
my $linkfilename = 'link_data_dbfile.txt';
tie (%hash, 'DB_File', $linkfilename, O_CREAT|O_RDWR, 0644, $DB_BTREE) || die $!;
opendir (DIR, $clipper_dir) ;
while (defined($file = readdir(DIR))){
  if ($file =~ /\.txt/) {
    push (@sub_list,$clipper_dir.$file);
    
  }
}
closedir (DIR);
my $filename;
foreach $filename(@sub_list)
{

 #if (-e "$clipper_dir/$filename"){print "$i $filename exists\n";next;}
 #print "$i\t$filename\n";

open (F,"$filename");
undef $/;
my $texthtml = <F>;
close(F);
$/ = "\n";

while ($texthtml =~ /^(\d+-\d+)\thttp:\/\/.*?\n(.*?)\n\n/mgi)
{
   $i++;
   
   $hash{$1} = $2;
}
close (FILE);
#last;
}
untie %hash;
print "$i links processed\n";
exit 1;
