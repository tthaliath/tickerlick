#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: in03_createwordlistfile.pl
#Date started : 02/14/04
#Last Modified : 02/14/04
#Purpose : Read the contents of an index file, create a file with all words


use strict;

my ($keyword,$key);
my ($page_id,$cnt);
my ($total,$links,%keyhash,$k,$rem,$text);
my ($id,$category,$keystr,$clink,$texthtml,$dest_file);
my $data_dir = "index/" ;
my $fullname;
my $file;
my ($term);
my @sub_list;
my (%termhash,$termfirst,$termnext,$termlist);
open (OUT,">termmaster.txt");

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

my %keyhash = ();
foreach $filename(@sub_list)
{
 $i++;
 print "$i\t$filename\n";
 $fullname = $data_dir.$filename;
 open (F,"<$fullname");
  while (<F>)
   {
     chomp;
     ($term) = split (/\t/,$_);
     #print "$term\n";
    $keyhash{$term}++;
    }
    close(F);
   #if ($i > 9){last;}
   }

 my ($j) = 0;  
    foreach $term(sort keys %keyhash)
    {
      $j++;
      print OUT "$term\t$keyhash{$term}\n";
}
close(OUT);
print "total terms:\t$j\n";


exit 1;


