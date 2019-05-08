#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: st04_clipper.pl
#Date started : 02/01/04
#Last Modified : 02/14/04
#Purpose : Read the contents of a text file, Remove all the unnecessary words 
#including pronouns,also store the links

use strict;
use Fcntl;
use POSIX;
use LWP::Simple; 

#require "ut15_stemmer.pl";
my $filename = $ARGV[0];
my $clipper_dir = "webdata/" ;
my $data_dir = "data3/" ;
my $fullname = $data_dir.$filename;
my ($orig_url,$content_type, $document_length, $modified_time, $expires, $server);
my ($j) = 0;
open (F,"$fullname");
undef $/;
my $texthtml = <F>;
close(F);
$/ = "\n";
my $dest_file = "$clipper_dir/$filename";
unlink($dest_file);
open (OUT,">$dest_file");
open (OUT1,">>invalidre12.txt");
open (OUT2,">>invalidre123.txt");
my ($url,$special_char_pat,$text);
#print "$fullname\n";
my ($stop_spec_char) = '\#|\`|\~|\!|\$|\%|\^|\&|\*|\+|\?|\[|\]|\{|\}|\*|\"|\'|\(|\)|\:|<|>';

while ($texthtml =~ /(.*?\t(http:\/\/.*?))\n(.*?)\n\n/mgi)
{
   $url = $1;
   $orig_url = $2;
   $text = $3;
   
   $text =~ s/\n/ /g;
   $text =~ s/c\+\+/cplusplus/gi;
   $text =~ s/c#/chash/gi;
   #Modified on 02/14/04
   #Replace special characters with space
   $special_char_pat = "_";
   $text =~ s/$special_char_pat/ /og;
   $text =~ s/\bon site\b/onsite/gi;
   $text =~ s/\boff shore\b/offshore/gi;
   $text =~ s/\bon-site\b/onsite/gi;
   $text =~ s/\boff-shore\b/offshore/gi;
   $text =~ s/\|/ /g;
   $text =~ s/mr\.|ms\.|mrs\.|dr\./ /gi;
   $text =~ s/\;/ /g;
   $text =~ s/$stop_spec_char/ /og;
   $text =~ s/cplusplus/c\+\+/g;
   $text =~ s/\bchash\b/c#/g;
   $text =~ s/\s+/ /g;
   
print OUT "$url\n$text\n\n";
}

close (OUT);

close (OUT1);
close (OUT2);
#print "total invalid:$j\n";
exit 1;
