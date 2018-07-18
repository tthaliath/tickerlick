#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: crawler1.pl
#Date started : 12/30/02
#Last Modified : 09/15/03
#Purpose : Read the contents of a URL from a text file, Extract all the links 
#(excluding redirect links) and store it in a file

my($url);
#Open file1
open (FILE1,"<siterest2.txt");
my $i = 0;
while(<FILE1>)
{
 chomp;
 ($id,$url,$desc) = split(/\t/,$_);
 #$url = lc $url;

++$i;
#if ($id > 1503){
system("perl linkextr1.pl $id $url");
#}
#last;
#if ($i > 49){last;}
} # EOF WHILE LOOP
close(FILE1);

print "$i url's processed";
exit 1;