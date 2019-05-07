#!d:\per\bin\perl -w
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: getlinks.pl
#Date started : 05/31/03
#Last Modified : 05/31/03
#Purpose : Extract company url's from web page
#--------------------------------------------------------------------------
#Modification History 
#
#	
#-------------------------------------------------------------------------
use strict ;
use URI::URL;

my ($id,$cloc,$cid,$cname,$orig_url,$domain,$firm,$value,$curl,$file,$key);
my $datafile = $ARGV[0];
my $spec_char = '&quot;|&amp;|&nbsp;|&gt;|&lt;|&euro;|&copy;';
open (F,"$datafile");
undef $/;
my $text = <F>;
close(F);
$/ = "\n";
$text =~ s/\n/ /g;
    $text =~ s/$spec_char/ /g;
    $text =~ s/<style.*?>.*?<\/style>/ /gi;
    $text =~ s/<LINK.*? REL=.*?>/ /gi;
    $text =~ s/<script.*?>.*?<\/script>/ /gi;
    $text =~ s/\&|\;/ /g;
    $text =~ s/\s+/ /g;
my ($url,%links,$linktext);
$linktext = "ttttt";
my $pat1 = 'location|href';
my $pat2 = 'html|htm|shtm|shtml|jsp|asp|cfm|pl|cgi';
while ($text =~ m/href.*?=.*?\"(.*?)\".*?>(.*?)\<\/a>/igs)
{
 
           $url = $1;
           $linktext = $2;
           if ($linktext =~ /.*?alt=\"(.*?)\"/i){
           $linktext = $1;
           }
           if ($linktext =~ /<font.*?>(.*?)<\/font>/i)
           {
            $linktext = $1;
            }
           #$url =~ s/^\.(.*)/$1/g;
           #print "$url\n";
           if ($url =~ /javascript:windowOpen\s?\([\'|\"](.*?)[\'|\"].*/i){$url = $1;}
           if ($url =~ /\'(.*?\.$pat2)\'/i){$url = $1;}
           $url = url($url,$orig_url)->abs;
           $links{$url} = $linktext; 
            
}

while ($text =~ m/location.*?=.*?[\"|\'](.*?)[\"|\']/igs)
{
 
           $url = $1;
           #print "$url\n";
           if ($url =~ /\'(.*?\.$pat2)\'/i){$url = $1;}
           $url = url($url,$orig_url)->abs;
           $links{$url} = $linktext; 
            
}

my $in ;
foreach $in (keys %links) {
   
    if ($in =~ m/\.gif$/i){next;}
    if ($in =~ m/\.jpg$/i){next;}
    if ($in =~ m/\.asx$/i){next;}
    if ($in =~ m/\.jpeg$/i){next;}
    if ($in =~ m/\.js$/i){next;}
    if ($in =~ m/\.pdf$/i){next;}
    if ($in =~ m/\.png$/i){next;}
    if ($in =~ m/\.zip$/i){next;}
    if ($in =~ m/\.ppt$/i){next;}
    if ($in =~ m/\.jar$/i){next;}
    if ($in =~ m/\.java$/i){next;}
    #if ($in =~ m/^http:\/\/download\.macromedia\.com/i){next;}
    if ($in =~ m/^http:\/\/www\.macromedia\.com/i){next;}
    if ($in =~ m/^http:\/\/active\.macromedia\.com/i){next;}
    if ($in =~ m/^http:\/\/www\.macromedia\.com/i){next;}
    if ($in =~ m/^http:(.*?)\.css/i){next;}
    if ($in =~ m/^http:(.*?)\.wmv/i){next;}
    if ($in =~ m/^http:(.*?)\.class/i){next;}
    if ($in =~ m/^http:(.*?)\.swf/i){next;}
    if ($in =~ m/javascript/i){next;}
    if ($in =~ m/mailto:/i){next;}
    if ($in =~ m/clsid:/i){next;}
    if ($in =~ m/download/i){next;}
    if ($in =~ m/^http:\/\/?$domain\/?$/) {next;}#To eliminate the base URL
    print "$in\t$links{$in}\n";

}

exit 1;

            