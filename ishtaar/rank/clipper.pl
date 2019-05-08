#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: clipper.pl
#Date started : 06/25/03
#Last Modified : 10/08/03
#Purpose : Read the contents of a text file, Remove all the unnecessary words 
#including pronouns,also store the links

use strict;
use Fcntl;
use POSIX;
use LWP::Simple; 

my $filename = $ARGV[0];
my $clipper_dir = "d:/ishtaar/rank/clipper/" ;
my $data_dir = "d:/ishtaar/rank/data/" ;
my $fullname = $data_dir.$filename;
my ($orig_url,$content_type, $document_length, $modified_time, $expires, $server);
open (F,"$fullname");
undef $/;
my $texthtml = <F>;
close(F);
$/ = "\n";
my $dest_file = "$clipper_dir/$filename";
unlink($dest_file);
open (OUT,">$dest_file");
my ($url,$special_char_pat,$text);
#print "$filename\n";
my ($stop_spec_char) = '\`|\~|\!|\$|\%|\^|\&|\*|\+|\?|\[|\]|\{|\}|\*|\"|\'|\(|\)|\:|<|>';
#my ($stop_spec_char) = '`|~|!|$|%|^|&|*|+|?|[|]|{|}';
my ($file_type) = 'htm|html|asp|jsp|pl|cgi|shtml';
#print "$texthtml\n";
while ($texthtml =~ /^(\d+-\d+\t(http:\/\/.*?))\n(.*?)\n\n/mgi)
{
   $url = $1;
   $orig_url = $2;
   $text = $3;
  #print "$url\t$orig_url\t$text\n";
   if ($orig_url =~ m/\.doc$/i){next;}
   if ($orig_url =~ m/\.jp/i){next;}
   if ($orig_url =~ m/\.mdb/i){next;}
   if ($orig_url !~ /[\.htm|\.html|\.asp|\.jsp|\.pl|\.cgi|\.shtml|\.cfm]$/i){
   #if ($orig_url !~ /[\.htm\?|\.html\?|\.asp\?|\.jsp\?|\.pl\?|\.cgi\?|\.shtml\?|\.cfm\?]/i){
   #print "$orig_url\n";
   #Get the header of the URL to check the type and last modified
  ($content_type, $document_length, $modified_time, $expires, $server) = head $orig_url;
  #if (!$content_type){exit;}
  #Exit if content type is not text
 if($content_type){ 
  my $ctype=$content_type;
  
  if($ctype!~/text/gi){
   open(TMP,">>clipperlog1.txt");
   print TMP "$url\n";
   close(TMP);
   next;
  }
}
}
#}
   #print "$orig_url\n";
   
   $text =~ s/\n/ /g;
   $text =~ s/http:\/\/.*?\s+/ /gi;
   #Replace special characters with space
   $special_char_pat = "\,|_";
   $text =~ s/$special_char_pat/ /og;
   $text =~ s/on site/onsite/gi;
   $text =~ s/off shore/offshore/gi;
   $text =~ s/on-site/onsite/gi;
   $text =~ s/off-shore/offshore/gi;
   #$text =~ s/\://g;
   $text =~ s/\;/ /g;
   #$text =~ s/\(|\)//g;
   #$text =~ s/\'//g;
   #$text =~ s/\"//g;
   #$text =~ s/\*|\|//g;
   #$text =~ s/\`|\~|\!|\$|\%|\^|\&|\*|\+|\?|\[|\]|\{|\}|\.//g;
   $text =~ s/$stop_spec_char/ /og;
   $text =~ s/\s+/ /g;
   
my $newtext = '';
my @lst;
my $i = -1;
my %stop_hash;
my @stop_words = qw/a all also an and are as at be been before but by can do each etc for from had has have he his how however i id if in inc into is it its limited ltd next not now of on or our per pvt she than that the their them then there thereby these they this those to ware was we were what when whenever where wherever which while who will with would you your/;
foreach (@stop_words) {$stop_hash{$_}++ };


#foreach (@lst){print "$_\n";}

map { $lst[++$i] = $_ }
               grep { !( exists $stop_hash{$_} ) }
               map lc, 
               split /\s+/, $text;

$newtext = join(" ",@lst);
$newtext =~ s/\d+?\.//g;
$newtext =~ s/\&/and/g;
print OUT "$url\n$newtext\n\n";
}

close (OUT);
exit 1;