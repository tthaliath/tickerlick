#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: linkextr12.pl
#Date started : 03/25/03
#Last Modified : 09/25/03
#Purpose : Read and save the contents of a URL, store it in a file 
# with the same name as url. Extract all the links 
#(excluding redirect links) and store it in a file

use LWP::Simple; 
use URI::URL;
#use HTML::Parse;
#Get all the global variables. Added by Thomas on 04/30/01


my ($debug,$name,$httpdir,$newstuff,$domain,$firm,$file,$parsed_html,$link,$full_url,$old);
$debug=0;

  $httpdir="d:/ishtaar/rank/linklist1";

#Get the URL from command argument.
my ($id,$url) = @ARGV;
print "$id\t$url\n";
my ($orig_url) = $url;

$url=~s#^http://##gi;               # strip off http://
$url=~s/(.*)#.*/$1/;
($domain=$url)=~s#^([^/]+).*#$1#;   # everything before first / is domain
$url =~ /.*?\.(.*?)\.(.*)/;
$firm = lc $1;
$file  = $1.'.txt';
#open(TMP,">>sitemasterlog.txt");
#print TMP "$id\t$orig_url\t$domain\t$file\t$cid\t$cname\n";
#close(TMP);


#undef $/ ;

#Get the header of the URL to check the type and last modified
my $headurl = $orig_url;
#print "$headurl\n";
my ($content_type, $document_length, $modified_time, $expires, $server) = head $headurl;



#if (!$content_type){exit;}
#Exit if content type is not text
if($content_type){ 
  my $ctype=$content_type;
  
  if($ctype!~/text/gi){
    open(TMP,">>sitemasterlog.txt");
   print TMP "$id - Content is not text\n";
   close(TMP);
    exit;
  }
}


# get the html into $texthtml
#print "$headurl\n";
my $texthtml = get $headurl;
#print "$texthtml\n";
# Exit when content is null
if (!$texthtml){
   open(TMP,">>sitemasterlog.txt");
   print TMP "$id - Unable to Process\n";
   close(TMP);
   exit;}

my $spec_char = '&quot;|&amp;|&nbsp;|&gt;|&lt;|&euro;|&copy;';
$texthtml =~ s/\s+/ /g;
#$texthtml =~ s/$spec_char/ /g;
#print "$texthtml\n";

# Extract the links from the html


  use HTML::LinkExtor;
  my $ua = new LWP::UserAgent;
  # Set up a callback that collect image links
  my @links = ();
  sub callback {
     my($tag, %attr) = @_;
     if ($tag ne 'form' && $tag ne 'img' && $tag ne 'embed' && $tag ne 'link'){  #  Do not pickup link if it is part of a FORM Tag. Added by Thomas on 04/19/01
     push(@links, values %attr);
   }
  }
  # Make the parser.  Unfortunately, we don't know the base yet
  # (it might be diffent from $url)
  my $p = HTML::LinkExtor->new(\&callback);
  # Request document and parse it as it arrives
  my $res = $ua->request(HTTP::Request->new(GET => $headurl),
                      sub {$p->parse($_[0])});
  # Expand all image URLs to absolute ones
  my ($link,$linktext,%linkhash);
  foreach $link(@links){
 
    
     
  if ($texthtml =~ m/href.*?=.*?\"$link\".*?>(.*?)\<\/a>/is)
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
        $linkhash{$link} = $linktext;
        
}

while ($texthtml =~ m/location=[\"|\'](.*?)[\"|\']/igs)
{
 
           #$url = $1;
           #print "$1\n";
           #if ($url =~ /\'(.*?\.$pat2)\'/i){$url = $1;}
           #$url = url($url,$orig_url)->abs;
           push(@links,$1);
            
}
#foreach $link(keys (%linkhash)){print "$link\t$linkhash{$link}\n";}
  my $base = $res->base;
  @links = map { $_ = url($_, $base)->abs; } @links;

#$domain = 'http://'.$domain;

# still need to return links
#my @lines = split(/\n/,$textlink) ;
my $in ;
my @linklist;
foreach $in (@links) {
    #print "$in\n";
    $in =~ s/(.*)\#.*$/$1/g;
    #$in =~ s/(.*)\#map$/$1/gi;
    if ($in =~ m/\.gif$/i){next;}
    if ($link =~ m/\.jpg$/i){next;}
    if ($link =~ m/\.asx$/i){next;}
    if ($link =~ m/\.jpeg$/i){next;}
    if ($link =~ m/\.png$/i){next;}
    if ($in =~ m/\.js$/i){next;}
    if ($in =~ m/\.pdf$/i){next;}
    if ($in =~ m/\.zip$/i){next;}
    if ($in =~ m/\.ppt$/i){next;}
    if ($in =~ m/\.jar$/i){next;}
    if ($in =~ m/\.java$/i){next;}
    if ($in =~ m/^http:(.*?)\.class/i){next;}
    if ($in =~ m/javascript/i){next;}
    if ($in =~ m/mailto:/i){next;}
    if ($in =~ m/clsid:/i){next;}
    if ($in =~ m/download/i){next;}
    if ($in =~ m/subscription/i){next;}
    if ($in =~ m/livechat/i){next;}
    if ($in =~ m/^http:\/\/?$domain\/?$/) {next;}#To eliminate the base URL
    push(@linklist,$in);

}

open(OUT, ">$httpdir/$file");
print OUT "$id\t$orig_url\n";
%aa = ();
foreach $value(@linklist){
 #$value = lc $value;
 if ($value =~ /$firm/i){
    $aa{$value}++;
   }
   }
foreach $key(keys %aa)
{
  print OUT "$id\t$key\n";
}
close(OUT);
exit 1;