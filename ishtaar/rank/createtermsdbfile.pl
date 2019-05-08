#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: createtermsdbfile.pl
#Date started : 12/27/03
#Last Modified : 12/27/03
#Purpose : Read the contents of an indexed file, get unique terms and store in DB file

use strict;
use DB_File;
my ($keyword);

my $data_dir = "d:/ishtaar/rank/index/" ;
my $fullname;
my $file;
my @sub_list;
my (%hash);
system('del termsdbfile.txt');
my $termsfilename = 'termsdbfile.txt';
tie (%hash, 'DB_File', $termsfilename, O_CREAT|O_RDWR, 0644, $DB_BTREE) || die $!;
my $i = 0;
opendir (DIR, $data_dir) ;
while (defined($file = readdir(DIR))){
  if ($file =~ /\.txt/) {
    push (@sub_list,$file);
    
  }
}
closedir (DIR);
my $filename;

foreach $filename(@sub_list)
{
 $i++;
 print "$i\t$filename\n";
 $fullname = $data_dir.$filename;

 open (F,"<$fullname");
 while (<F>){
  chomp;
  ($keyword) = split(/\t/,$_);
   #print "$keyword\n";
  if ($keyword =~ /[a-z]/){
  if ($keyword =~ /^-?(.*)/){$keyword = $1;}
  $hash{$keyword}++;}
  
 }


close (F);
}
untie %hash;

                           
exit 1;

 