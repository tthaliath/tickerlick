#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: validlinks.pl
#Date started : 10/12/03
#Last Modified : 10/15/03
#Purpose : Read the contents of files from clipper folder, get all the links and validate against
            linkmasterdbfile.txt, create validlinksmaster.txt

use strict;
use DB_File;

my $clipper_dir = "d:/ishtaar/rank/clipper/" ;
my $fullname;
my $file;
my ($in,$header,%hash,%hash1,$fileid);
my @sub_list;

my $i = 0;
my ($key);
my $linkfilename = 'linkmasterdbfile.txt';
tie (%hash, 'DB_File', $linkfilename, O_CREAT|O_RDWR, 0644, $DB_BTREE) || die $!;
opendir (DIR, $clipper_dir) ;
while (defined($file = readdir(DIR))){
  if ($file =~ /\.txt/) {
    push (@sub_list,$clipper_dir.$file);
    
  }
}
closedir (DIR);
open (NOLINK,">nolink.txt");
my $filename;
open (FILE,">validlinksmaster.txt");
foreach $filename(@sub_list)
{

 #if (-e "$clipper_dir/$filename"){print "$i $filename exists\n";next;}
 #print "$i\t$filename\n";

open (F,"$filename");
undef $/;
my $texthtml = <F>;
close(F);
$/ = "\n";


while ($texthtml =~ /^(\d+-\d+)\thttp:\/\/.*?\n.*?\n\n/mgi)
{
 $i++;
   $fileid = $1;
   
   $hash1{$1}++;
   if ($hash{$1}){
    print FILE "$1\t$hash{$1}\n";
    }
   else{print NOLINK "filename:$filename   $1 does not exist\n";}   
   #if ($fileid =~ /68-1$/){print "$fileid\t$filename\n";}
}
}
close (FILE);
close (NOLINK);
untie %hash;
print "$i links processed\n";
foreach $key (keys (%hash1))
{
  if ($hash1{$key} > 1){print "$key\t$hash1{$key}\n";}
  #print "$key\t$hash1{$key}\n";
}
exit 1;