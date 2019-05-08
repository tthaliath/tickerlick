#!/usr/perl/perl
#Author : Thomas Thaliath 
#Program File: cr04_linkextr.pl
#Date started : 12/28/03
#Last Modified : 12/28/03
#Purpose : Read and save the contents of a URL, store it in a file 
# with the same name as url. Extract all the links 
#(excluding redirect links) and store it in a file

use strict;

use Fcntl;
use POSIX;
use LWP::Simple; 
use URI::URL;
#use HTML::Parse;
#Get all the global variables. Added by Thomas on 04/30/01


my ($httpdir,$domain,$full_url,$firm);


  $httpdir="linklist2";
my $httptemp="linklist2/temp";

#Get the URL from command argument.
my ($file,$id,$url,$linktextmain) = @ARGV;
my ($orig_url) = $url;

#print "$file\t$id\t$url\t$linktextmain\n";

$url=~s#^http://##gi;               # strip off http://
$url=~s/(.*)#.*/$1/;
($domain=$url)=~s#^([^/]+).*#$1#;   # everything before first / is domain
$url =~ /.*?\.(.*?)\.(.*)/;
$firm = $1;
#my ($tempfile) = $file.'.tmp';



undef $/ ;

#Get the header of the URL to check the type and last modified
my $headurl = $orig_url;
my ($content_type, $document_length, $modified_time, $expires, $server) = head $headurl;



if (!$content_type){exit;}
#Exit if content type is not text
if($content_type){ 
  my $ctype=$content_type;
  
  if($ctype!~/text/gi){
    open(TMP,">>sitelinklog.txt");
   print TMP "Content is not text,$id\t$orig_url\n";
   close(TMP);
    exit;
  }
}


#open(OUT, ">>$httpdir/$file");
#print OUT "$orig_url\n";

# get the html into $texthtml
my $texthtml = get $headurl;
# Exit when content is null
if (!$texthtml){
   open(TMP,">>sitelinklog.txt");
   print TMP "Unable to Process,$id\t$orig_url\n";
   close(TMP);
   exit;}

my $spec_char = '&quot;|&amp;|&nbsp;|&gt;|&lt;|&euro;|&copy;|&raquo;';
$texthtml =~ s/\s+/ /g;
if ($linktextmain){$linktextmain =~ s/$spec_char/ /ig;}
#$texthtml =~ s/$spec_char/ /g;
#print "$texthtml\n";

# Extract the links from the html


  use HTML::LinkExtor;
  my $ua = new LWP::UserAgent;
  # Set up a callback that collect image links
  my @links = ();
  #my @links1 = ();
  sub callback {
     my($tag, %attr) = @_;
     if ($tag ne 'form' &&  $tag ne 'embed'){  #  Do not pickup link if it is part of a FORM Tag. Added by Thomas on 04/19/01
     push(@links, values %attr);
   }
  }
  # Make the parser.  Unfortunately, we don't know the base yet
  # (it might be diffent from $url)
  my $p = HTML::LinkExtor->new(\&callback);
  # Request document and parse it as it arrives
  my $res = $ua->request(HTTP::Request->new(GET => $headurl),
                      sub {$p->parse($_[0])});
 
     
  #while ($texthtml =~ m/<a.*?href.*?=.*?\"(.*?)\".*?<\/a>/igs)
#{
 #         print "$1\n";
 #        push(@links,$1);
#}

while ($texthtml =~ m/location=[\"|\'](.*?)[\"|\']/igs)
{
 
           #$url = $1;
           #print "$1\n";
           #if ($url =~ /\'(.*?\.$pat2)\'/i){$url = $1;}
           #$url = url($url,$orig_url)->abs;
           push(@links,$1);
            
}
#foreach $link(keys (%linkhash)){print "$link\t$linkhash{$link}\n";}

#$domain = 'http://'.$domain;

# still need to return links
#my @lines = split(/\n/,$textlink) ;
my $in ;
my @linklist;
open (TMP,">>$httptemp/$file");
#my $stop_word = "[gif|jpg|asx|png|jpeg|css|pdf|js|zip|jar|java|class|ppt]";
my ($stop_language) = 'chinese|japanese|german|french|russian|china|spanish|spain|japan|russia|france';
my ($pat) = "safe_harbor|events|investor|management|certification|advisory|analyst|press|directions|advisoryboard|registration|privacy";
@linklist = ();
foreach $in (@links) {
    #print "$in\n";
    $in =~ s/(.*)\#.*$/$1/g;
    if ($in =~ /$stop_language/i) {print TMP "$in\n";next;}
    if ($in =~ /$pat/i) {print TMP "$in\n";next;}
    if ($in =~ m/\.gif$/i){next;}
    if ($in =~ m/\.jpg$/i){next;}
    if ($in =~ m/\.mpg$/i){next;}
    if ($in =~ m/\.ico$/i){next;}
    if ($in =~ m/\.mpeg$/i){next;}
    if ($in =~ m/\.jpeg$/i){next;}
    if ($in =~ m/\.wmv$/i){next;}
    if ($in =~ m/\.js$/i){next;}
    if ($in =~ m/\.png$/i){next;}
    if ($in =~ m/\.pdf$/i){next;}
    if ($in =~ m/\.css$/i){next;}
    if ($in =~ m/\.zip$/i){next;}

    if ($in =~ m/\.exe$/i){next;}
    if ($in =~ m/\.bmp$/i){next;}
    if ($in =~ m/\.ram$/i){next;}
    if ($in =~ m/\.mov$/i){next;}
    if ($in =~ m/\.mp3$/i){next;}
    if ($in =~ m/\.vot$/i){next;}
    if ($in =~ m/\.tif$/i){next;}
    if ($in =~ m/\.ps$/i){next;}
    if ($in =~ m/\.jp$/i){next;}
    if ($in =~ m/\.ru$/i){next;}
    if ($in =~ m/\.rm$/i){next;}
    if ($in =~ m/\.doc$/i){next;}
    if ($in =~ m/\.swf$/i){next;}
    if ($in =~ m/\.gz$/i){next;}

    if ($in =~ m/\.ppt$/i){next;}
    if ($in =~ m/\.pps$/i){next;}
    if ($in =~ m/\.jar$/i){next;}
    if ($in =~ m/\.java$/i){next;}
    if ($in =~ m/\.mdb$/i){next;}
    if ($in =~ m/\.class/i){next;}
    if ($in =~ m/\.xls/i){next;}
    if ($in =~ m/^http:\/\/download\.macromedia\.com/i){next;}
    if ($in =~ m/^http:\/\/www\.macromedia\.com/i){next;}
    if ($in =~ m/^http:\/\/active\.macromedia\.com/i){next;}
    if ($in =~ m/^http:\/\/www\.macromedia\.com/i){next;}
    if ($in =~ m/^http:(.*?)\.css/i){next;}
    if ($in =~ m/^http:(.*?)\.wmv/i){next;}
    if ($in =~ m/^http:(.*?)faq\./i){next;}
    if ($in =~ m/^http:(.*?)\.class/i){next;}
    if ($in =~ m/^http:(.*?)\.swf/i){next;}
    if ($in =~ m/javascript/i){next;}
    if ($in =~ m/mailto:/i){next;}
    if ($in =~ m/clsid:/i){next;}
    if ($in =~ /print\.php/i) {next;}
    
    if ($in =~ m/contact/i) {print TMP "$in\n";next;}
    if ($in =~ m/article/i) {print TMP "$in\n";next;}
    if ($in =~ m/jobs/i) {print TMP "$in\n";next;}
    if ($in =~ m/disclaimer/i) {print TMP "$in\n";next;}
    if ($in =~ m/career/i) {print TMP "$in\n";next;}
    if ($in =~ m/archive/i) {print TMP "$in\n";next;}
    if ($in =~ m/feedback/i) {print TMP "$in\n";next;}
    if ($in =~ m/sitemap/i) {print TMP "$in\n";next;}
    if ($in =~ m/download/i) {print TMP "$in\n";next;}
    if ($in =~ m/testimonial/i) {print TMP "$in\n";next;}
    #if ($in =~ m/about/i) {print TMP "$in\n";next;}
    #if ($in =~ m/news/i) {print TMP "$in\n";next;}
    if ($in =~ m/copyright\./i) {print TMP "$in\n";next;}
    if ($in =~ m/map\./i) {print TMP "$in\n";next;}
    if ($in =~ m/login\./i) {print TMP "$in\n";next;}
     if ($in =~ m/faq\./i) {print TMP "$in\n";next;}
    if ($in =~ m/legal/i) {print TMP "$in\n";next;}
    if ($in =~ /\/search/i) {print TMP "$in\n";next;}
    if ($in =~ m/pressrelease/i) {print TMP "$in\n";next;}
    if ($in =~ m/livechat/i) {print TMP "$in\n";next;}
    if ($in =~ m/subscription/i){print TMP "$in\n";next;}
    if ($in =~ m/investor/i){print TMP "$in\n";next;}
    if ($in =~ m/privacy/i){print TMP "$in\n";next;}
    #if ($in =~ m/^http:\/\/sitefinder\.verisign\.com/i){next;}
    if ($in =~ /investor/i){print "INVESTOR:$in\n";next;}
    push(@linklist,$in);

}
close(TMP);
my ($link,$linktext,%linkhash);
  
foreach $link(@linklist){
 
  #print "$link\n";
  if($texthtml =~ m/<a.*?href=\"$link\".*?>(.*?)\<\/a>/is)
{
 
           $linktext = $1;
           if ($linktext =~ /.*?alt=\"(.*?)\"/is){
           $linktext = $1;
           }
           if ($linktext =~ /<font.*?>(.*?)<\/font>/is)
           {
            $linktext = $1;
            }
      
}

if ($linktext !~ /<img/i){
$linktext =~ s/<br>|<b>|<\/b>|<strong>|<\/strong>//ig;
$linktext =~ s/$spec_char/ /g;
$linkhash{$link} = $linktext;
$linktext = "";      
 }       
}




 # Expand all image URLs to absolute ones
my ($link1,%aa);
my $base = $res->base;
  foreach $link (keys (%linkhash)){
  
   $link1 = url($link, $base)->abs; 
   if ($link1 =~ /$firm/i){
   $aa{$link1} = $linkhash{$link}; 
  }
 } 

foreach $link(keys (%aa)){

if (!$aa{$link})
{
   if ($link =~ /.*\/(.*?)\./)
{

   $linktext = $1;
   #print "$link\t$linktext\n";
   $linktext =~ s/-|_|\./ /ig;
   $aa{$link} = $linktext;
}
}
} 

#Let all the main links be hub and links extracted from main links are authoritatative.
my ($hub,$auth) = (0,1);
open(OUT, ">>$httpdir/$file");
print OUT "$id\t$orig_url\t$linktextmain\t$hub\n";

#Let all the main links be hub and links extracted from main links are authoritatative.
my ($auth) = 1;
my $key;
foreach $key(keys %aa)
{

  print OUT "$id\t$key\t$aa{$key}\t$auth\n";
}
close(OUT);
exit 1;
