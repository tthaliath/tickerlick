#!d:\perl\bin\perl
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
#Open file1
open (FILE1,"<$link_dir/$filename");
open (FILE2,">$webdata_dir/$filename");
open (FILE3,">>linkextrlog1.txt");


my ($text,$fileid,$linkid,$keywords,$title);
my $flag = 0;
my $metaflag = 0;
my $i = 0;

my $spec_char = '&quot;|&amp;|&nbsp;|&gt;|&lt;|&euro;|&copy;';

@linklist = ();
while(<FILE1>)
{
 chomp;
  ($id,$value,$linktext,$pagetype) = split (/\t/,$_);
  $linktext =~ s/<.*?>//g;
  if ($value =~ /korea/i){next;}
  #$linktext =~ s/\s+/ /g;
  $linktext =~ s/\&nbsp\;//gi;
  #print "$id\n$value\n";

    #$texthtml =~ s/^$//g;
   #print "$value\n"; 
    my ($content_type, $document_length, $modified_time, $expires, $server) = head $value;

   if (!$content_type){next;}
   if($content_type !~ /text/gi){
    print FILE3 "File:$filename\tUrl:$value\tNot a text page\n";  
    next;
   }
    #get the html into $texthtml
    #print "$value\n";
   $value =~ s/\/\.\.\//\//g;
    $text = get $value;
    #print "$text\n";
    if (!$text)
    {
      print FILE3 "File:$filename\tUrl:$value\tUnable to process\n"; 
      next;  
    }
    
    
    $text =~ s/\n//g;
    
    print FILE2 "$id\t$value\n"; 
    print FILE2 "$text\n\n"; 
   
    
 }
  
 

close(FILE1);
close(FILE2);
close(FILE3);

exit 1;
