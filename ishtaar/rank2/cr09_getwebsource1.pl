#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: cr06_getwebsource.pl
#Date started : 12/30/03
#Last Modified : 01/03/04
#Purpose : fetch the web page source from each URL, store it. also, remove tags and spe. characters
#and store it in different folder

#Modification
# 01/03/04: Removed the code for clipping

use strict;
use LWP::Simple; 

my($num,$url,$city,$id,$link,$value,$key,$in,$domain,@linklist,$filename);
my ($title,$linktext,$pagetype,$linkid,$webdata);

$filename = @ARGV[0];

my $link_dir = "linklist2" ;
my $webdata_dir = "websrc" ;
my $webdata_dir1 = "websrc1" ;
#Open file1
open (FILE1,"<$link_dir/$filename");
open (FILE2,"<$webdata_dir/$filename");
open (FILE3,">$webdata_dir1/$filename");


my ($text,$fileid,$linkid,$keywords,$title);
my $flag = 0;
my $metaflag = 0;
my $i = 0;

my %linklist;
while(<FILE1>)
{
 chomp;
  ($id,$value,$linktext,$pagetype) = split (/\t/,$_);
  $linktext =~ s/<.*?>//g;
  #$linktext =~ s/\s+/ /g;
  $linktext =~ s/\&nbsp\;//gi;
  #print "$id\n$value\n";
  $linklist{$id} = "$value\t$linktext\t$pagetype";
    
   }
  
 while (<FILE2>)
  {
    chomp;
    if (/^(\d+-\d+)\t/)
    {
       print FILE3 "$1\t$linklist{$1}\n";
    }
    else
    {
       s// /g;
       
       print FILE3 "$_\n";
    }
 }

close(FILE1);
close(FILE2);
close(FILE3);

exit 1;
