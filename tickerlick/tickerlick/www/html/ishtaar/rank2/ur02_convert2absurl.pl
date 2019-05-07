#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: ur02_convert2absurl.pl
#Date started : 01/01/04
#Last Modified : 01/01/04
#Purpose : Read the contents of a web source file, exapand all relative url to 
#absolute url and store the file.

use strict;
use Fcntl;
use POSIX;
use LWP::Simple; 
use URI::URL;

my $filename = $ARGV[0];
my $websrc_dir = "websrc2/" ;
my $data_dir = "websrc/" ;
my $fullname = $data_dir.$filename;
my ($orig_url,$newtext);
open (F,"$fullname");
undef $/;
my $texthtml = <F>;
close(F);
$/ = "\n";
my $dest_file = "$websrc_dir/$filename";
unlink($dest_file);
open (OUT,">$dest_file");
my ($url,$u1,$u2,$text,$link);
#print "$dest_file\n";
while ($texthtml =~ /^(\d+-\d+\t(http:\/\/.*?))\n(.*?)\n\n/mgi)
{
   $url = $1;
   $orig_url = $2;
   $text = $3;
    ##while ($text =~ m/<a.*?href.*?=.*?\"(.*?)\".*?<\/a>/igs)
#{
    $text =~ s/(<a.*?href.*?=.*?\")(.*?)(\".*?<\/a>)/$1.&replaceurl($2,$orig_url).$3/igse; 
    $text =~ s/(<img.*?src.*?=.*?\")(.*?)(\".*?>)/$1.&replaceurl($2,$orig_url).$3/igse; 
    $text =~ s/(background.*?=.*?\")(.*?)(\".*?>)/$1.&replaceurl($2,$orig_url).$3/igse; 
 $text =~ s/(type.*?=.*?image.*?src.*?=.*?\")(.*?)(\".*?>)/$1.&replaceurl($2,$orig_url).$3/igse;
    #$text =~ s/(<a.*?href.*?=.*?\")(.*?)(\".*?<\/a>)|(<img.*?src.*?=.*?\")(.*?)(\".*?>)|(background.*?=.*?\")(.*?)(\".*?>)/$1.&replaceurl($2,$orig_url).$3/igse;
       
#}
 
$text =~ s// /g;
print OUT "$url\n$text\n\n";
 
#last;

}

close (OUT);
exit 1;

sub replaceurl{
  my ($rel_url) = shift;
  my ($orig_url) = shift;
  
  my $u1 = URI::URL->new($rel_url, $orig_url);
  my $u2 = $u1->abs;
  #print "$u2\n";
  return $u2;
}
          
