#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: cr01_crawler.pl
#Date started : 12/28/03
#Last Modified : 12/28/03
#Purpose : Read the contents of a URL from a text file, Extract all the links 
#(excluding redirect links) and store it in a file

my($url);
#Open file1
open (FILE1,"<siteallrerun.txt");
my $i = 0;
while(<FILE1>)
{
 chomp;
 ($id,$url,$desc,$size) = split(/\t/,$_);
 #$url = lc $url;

++$i;

print "$i:$id:$url\n";
#if ($id == 1142 ){
system("perl cr02_linkextr.pl $id $url");
#}
#if ($i > 10){last};

} # EOF WHILE LOOP
close(FILE1);

print "$i url's processed";
exit 1;
