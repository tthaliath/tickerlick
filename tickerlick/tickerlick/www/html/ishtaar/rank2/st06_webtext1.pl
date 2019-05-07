#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: cr06_getwebsource.pl
#Date started : 12/30/03
#Last Modified : 12/30/03
#Purpose : fetch the web page source from each URL, store it. also, remove tags and spe. characters
#and store it in different folder

use strict;
use LWP::Simple; 

my($num,$url,$city,$id,$link,$value,$key,$in,$domain,@linklist,$filename);
my ($title,$linktext,$pagetype,$linkid,$webdata);

$filename = @ARGV[0];


my $data_dir = "data3" ;
my $webdata_dir = "websrc1" ;
#Open file1
open (FILE1,"<$webdata_dir/$filename");
open (FILE2,">$data_dir/$filename");
my ($text,$fileid,$linkid,$keywords,$title);
my $flag = 0;
my $metaflag = 0;
my $i = 0;

my $spec_char = '&quot;|&amp;|&nbsp;|&gt;|&lt;|&euro;|&copy;';

@linklist = ();
undef $/;
my $texthtml = <FILE1>;
close(FILE1);
$/ = "\n";

my ($url,$special_char_pat,$text,$orig_url,$sel);
while ($texthtml =~ /^(\d+-\d+?)\t(http:\/\/.*?)\t(.*?)\t(.*?)\n(.*?)\n\n/mgi)
{
   $id = $1;
   $value = $2;
   $text = $5;
    if ($text =~ /.*?(<body.*?<\/body>).*/i){$text =$1;}
    $text =~ s/\n/ /g;
    $text =~ s/$spec_char/ /g;
    $text =~ s/<style.*?>.*?<\/style>/ /gi;
    $text =~ s/<LINK.*? REL=.*?>/ /gi;
    $text =~ s/<script.*?>.*?<\/script>/ /gi;
    $text =~ s/<select .*?>.*?<\/select>/ /gi;
    $text =~ s/<.*?>/ /g;
    $text =~ s/\&|\;/ /g;
    $text =~ s/\s+/ /g;
    if ($text){
    print FILE2 "$id\t$value\n"; 
    print FILE2 "$text\n\n"; 
    
    }
 }
  
 
$texthtml='';
$text='';
close(FILE1);
close(FILE2);
exit 1;
