#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: crawler1.pl
#Date started : 12/30/02
#Last Modified : 09/15/03
#Purpose : Read the contents of a URL from a text file, Extract all the links 
#(excluding redirect links) and store it in a file

my($id,$url,%aa);
#Open file1
open(IN,"siteallnew.txt");

while(<IN>){
 chomp;
 ($id,$url,$loc,$desc) = split(/\t/,$_);
 $aa{$id} = $_;
 print "$id\n";
}

close (IN);
#foreach $key (keys(%aa)){print "$aa{$id}\n";}
open(OUT,">sitererun1.txt");
open (FILE1,"<sitererun.txt");
my $i = 0;
while(<FILE1>)
{
 chomp;
 ($id) = split(/\t/,$_);
  
 print OUT "$aa{$id}\n";

++$i;

#if ($id > 1503){
#system("perl linkextr1.pl $id $url");
#}

#if ($i > 49){last;}
} # EOF WHILE LOOP
close(FILE1);
close(OUT);
print "$i url's processed";
exit 1;