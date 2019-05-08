#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath
#Program File: cr02_linkextr.pl
#Date started : 12/28/03
#Last Modified : 12/28/03
#Purpose : Read and save the contents of a URL, store it in a file
# with the same name as url. Extract all the links
#(excluding redirect links) and store it in a file
use LWP::Simple;
use URI::URL;
#use HTML::Parser;
#Get all the global variables. Added by Thomas on 04/30/01


my ($debug,$name,$httpdir,$newstuff,$domain,$firm,$file,$parsed_html,$link,$full_url,$old);
$debug=0;

  $httpdir="/home/tthaliat/dev1/rank2/linklist1";

#Get the URL from command argument.
my ($id,$url) = @ARGV;
print "$id\t$url\n";
my ($orig_url) = $url;

$url=~s#^http://##gi;               # strip off http://
$url=~s/(.*)#.*/$1/;
($domain=$url)=~s#^([^/]+).*#$1#;   # everything before first / is domain
$url =~ /.*?\.(.*?)\.(.*)/;
$firm = lc $1;
#print "$firm\n";
$file  = $1.'.txt';
#open(TMP,">>sitemasterlog.txt");
#print TMP "$id\t$orig_url\t$domain\t$file\t$cid\t$cname\n";
#close(TMP);
if (-e "$httpdir/$file"){print "$i $file exists\n";exit;}

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

my $spec_char = '&quot;|&amp;|&nbsp;|&gt;|&lt;|&euro;|&copy;|&raquo;';
$texthtml =~ s/\s+/ /g;
$texthtml =~ s/$spec_char/ /g;
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
my ($stop_language) = 'chinese|japanese|german|french|russian|china|spanish|spain|japan|russia|france';
#my ($pat) = "safe_harbor|events|investor|management|certification|advisory|analyst|press|directions|advisoryboard|registration|privacy";
@linklist = ();
foreach $in (@links) {
    #print "$in\n";
    $in =~ s/(.*)\#.*$/$1/g;
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

    if ($in =~ /\.png$/i){next;}
    if ($in =~ /\.asx$/i){next;}
    if ($in =~ m/\.wmv$/i){next;}

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
    if ($in =~ /javascript/i){next;}
    if ($in =~ /mailto:/i){next;}
    if ($in =~ /clsid:/i){next;}
    if ($in =~ /download/i){next;}
    if ($in =~ /subscription/i){next;}
    if ($in =~ /livechat/i){next;}
    if ($in =~ /$stop_language/i) {next;}
    if ($in =~ /^http:\/\/?$domain\/?$/) {next;}#To eliminate the base URL
    push(@linklist,$in);

}

my ($link,$linktext,%linkhash);

foreach $link(@linklist){

  #print "$link\n";
  $linktext = "";
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
$linktext =~ s/<br>//ig;

 }
else
{
  $linktext = "";
}
$linkhash{$link} = $linktext;
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
   $linktext =~ s/-|_|\./ /g;
   $aa{$link} = $linktext;
}
}
}
open(OUT, ">$httpdir/$file");
print OUT "$id\t$orig_url\n";

my $j = 1;
foreach $key(keys %aa)
{
  $j++;
  #print "$id\t$key\t$aa{$key}\n";
  print OUT "$id\t$key\t$aa{$key}\n";
}
close(OUT);
print "total links:$j\n";
open (NOLINK,">>urllinkdata.txt");
print NOLINK "$id\t$orig_url\t$j\n";
close (NOLINK);
exit 1;
