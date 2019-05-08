#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: preparedesc.pl
#Date started : 05/21/03
#Last Modified : 09/30/03
#Purpose : fetch the web page source from each URL, remove tags and spe. characters
#and store it

use strict;
use LWP::Simple; 

my($num,$url,$city,$id,$link,$value,$key,$in,$domain,@linklist,$filename);
my ($title,$linktext,$pagetype,$linkid,$webdata);

$filename = @ARGV[0];

my $link_dir = "d:/ishtaar/rank/linklist2" ;
my $data_dir = "d:/ishtaar/rank/data" ;
my $webdata_dir = "d:/ishtaar/rank/websrc" ;
#Open file1
open (FILE1,"<$link_dir/$filename");
open (FILE2,">$data_dir/$filename");
open (FILE3,">>linkextrlog2.txt");
open (FILE4,">>datafilelog2.txt");
open (FILE5,">>companymetadata2.txt");
open (FILE6,">>linkmetadata2.txt");
open (FILE7,">$webdata_dir/$filename");
my ($text,$fileid,$linkid,$keywords,$title);
my $flag = 0;
my $metaflag = 0;
my $i = 0;
my ($stop_language) = 'chinese|japanese|german|french|russian|china|spanish|spain|japan|russia|france';
my $spec_char = '&quot;|&amp;|&nbsp;|&gt;|&lt;|&euro;|&copy;';
my $pat = "investor|management|certification|advisory|analyst|casestudies|press|directions|advisoryboard|registration|privacy";
@linklist = ();
while(<FILE1>)
{
 chomp;
  ($id,$value,$linktext,$pagetype) = split (/\t/,$_);
  $linktext =~ s/<.*?>//g;
  #$linktext =~ s/\s+/ /g;
  $linktext =~ s/\&nbsp\;//gi;
  

    #$texthtml =~ s/^$//g;
    if ($value =~ /\.exe$/i){print FILE4 "$id\t$value\n";next;}
    if ($value =~ /\.ico$/i){print FILE4 "$id\t$value\n";next;}
    if ($value =~ /\.bmp$/i){print FILE4 "$id\t$value\n";next;}
    if ($value =~ /\.ppt$/i){print FILE4 "$id\t$value\n";next;} 
    if ($value =~ /\.pps$/i){print FILE4 "$id\t$value\n";next;} 
    if ($value =~ /\.ram$/i){print FILE4 "$id\t$value\n";next;} 
    if ($value =~ /\.mov$/i){print FILE4 "$id\t$value\n";next;} 
    if ($value =~ /\.mp3$/i){print FILE4 "$id\t$value\n";next;} 
    if ($value =~ /\.mpg$/i){print FILE4 "$id\t$value\n";next;} 
    if ($value =~ /\.wot$/i){print FILE4 "$id\t$value\n";next;} 
    if ($value =~ /\.tif$/i){print FILE4 "$id\t$value\n";next;} 
    if ($value =~ /\.ps$/i){print FILE4 "$id\t$value\n";next;} 
    if ($value =~ /\.jp$/i){print FILE4 "$id\t$value\n";next;} 
    if ($value =~ /\.ru$/i){print FILE4 "$id\t$value\n";next;} 
    if ($value =~ /\.rm$/i){print FILE4 "$id\t$value\n";next;} 
    if ($value =~ /\.doc$/i){print FILE4 "$id\t$value\n";next;}
    if ($value =~ /\.swf$/i){print FILE4 "$id\t$value\n";next;} 
    if ($value =~ /\.gz$/i){print FILE4 "$id\t$value\n";next;} 
    #if ($value =~ /^http:\/\/sitefinder\.verisign\.com/i){next;}
    if ($value =~ /$pat/i){print FILE4 "$id\t$value\n";next;}
    if ($value =~ /print\.php/i){print FILE4 "$id\t$value\n";next;}
    if ($value =~ /$stop_language/i) {next;}
    my ($content_type, $document_length, $modified_time, $expires, $server) = head $value;

   if (!$content_type){next;}
   if($content_type !~ /text/gi){
    print FILE3 "File:$filename\tUrl:$value\tNot a text page\n";  
    next;
   }
    #get the html into $texthtml
    #print "$value\n";
    $text = get $value;
    #print "$text\n";
    if (!$text)
    {
      print FILE3 "File:$filename\tUrl:$value\tUnable to process\n"; 
      next;  
    }
    
    $webdata = $text;
    if(!$metaflag)
     {
       $id =~ /(.*?)-(.*)/;
       $linkid = $2;
       if ($linkid == 1){
        $fileid = $1;
        $keywords = "";
        if ($text =~ /<meta.*content=\"(.*?)\".*?name=keywords>/gsi)
          {
            #print "1$filename\t$value\n";
            $keywords = $1;
          }
        else
          {
          if ($text =~ /<meta\s+name=\"keywords\".*?=\"(.*?)\">/gsi)
           {
            #print "2$filename\t$value\n";
            $keywords = $1;
           }
          }
         print FILE5 "$fileid\t$value\t$keywords\n";
         $metaflag = 1;
        }
     }

    if ($text =~ /<title>(.*?)<\/title>/gsi)
         {
            #print "1$filename\t$value\n";
            $title = $1;
            if ($title){$title =~ s/\&amp\;//g};
         }
    $text =~ s/\n/ /g;
    $text =~ s/$spec_char/ /g;
    $text =~ s/<style.*?>.*?<\/style>/ /gi;
    $text =~ s/<LINK.*? REL=.*?>/ /gi;
    $text =~ s/<script.*?>.*?<\/script>/ /gi;
    #$text =~ s/<\/?font.*?>//gi;
    #$text =~ s/<\/?form.*?>//gi;
    #$text =~ s/<a.*?>//gi;
    #$text =~ s/<img.*?>//gi;
    #$text =~ s/<\/a.*?>//g;
    $text =~ s/<.*?>/ /g;
    $text =~ s/\&|\;/ /g;
    $text =~ s/\s+/ /g;
    if ($text){
    print FILE2 "$id\t$value\n"; 
    print FILE2 "$text\n\n"; 
    print FILE7 "$id\t$value\n"; 
    print FILE7 "$webdata\n\n"; 
    }
    #update linkdata master
    print FILE6 "$id\t$value\t$linktext\t$pagetype\t$title\n";
 }
  
 

close(FILE1);
close(FILE2);
close(FILE3);
close(FILE4);
close(FILE5);
close(FILE6);
close(FILE7);
exit 1;