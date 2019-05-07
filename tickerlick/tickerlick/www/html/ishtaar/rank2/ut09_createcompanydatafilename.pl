#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: ut09_createcompanydatafilename.pl 
#Date started : 09/18/04
#Last Modified : 09/18/04

use strict;
my ($domain,$filename,$firm);
#Open file1
open (FILE1,"<siteallnew3.txt");
open (OUT,">sitemaster.txt");
my $i = 0;
while(<FILE1>)
{
 chomp;
  my ($id,$url,$loc,$desc,$size) = split(/\t/,$_);
 $url=~s#^http://##gi;               # strip off http://
 $url=~s/(.*)#.*/$1/;
 ($domain=$url)=~s#^([^/]+).*#$1#;   # everything before first / is domain
  $url =~ /.*?\.(.*?)\.(.*)/;
 $firm = lc $1;
 $filename = $firm.lc($2);
 $filename =~ s/^(.*?)\/(.*)/\1/g;
 $filename =~ s/\.//g;
 if ($desc){
 print OUT "$id\t$url\t$loc\t$desc\t$size\t$firm\t$filename\n";
 }
else{print "$_\n";}

++$i;

} # EOF WHILE LOOP
close(FILE1);
close(OUT);
print "$i url's processed";
exit 1;
