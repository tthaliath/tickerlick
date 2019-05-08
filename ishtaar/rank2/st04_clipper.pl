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

require "ut15_stemmer.pl";
my $filename = $ARGV[0];
my $clipper_dir = "clipper1/" ;
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
open (OUT1,">>invalidre.txt");
open (OUT2,">>invalidre1.txt");
my ($url,$special_char_pat,$text);
#print "$fullname\n";
my ($stop_spec_char) = '\#|\`|\~|\!|\$|\%|\^|\&|\*|\+|\?|\[|\]|\{|\}|\*|\"|\'|\(|\)|\:|<|>';
#my ($stop_spec_char) = '`|~|!|$|%|^|&|*|+|?|[|]|{|}';

#print "$texthtml\n";
while ($texthtml =~ /(.*?\t(http:\/\/.*?))\n(.*?)\n\n/mgi)
{
   $url = $1;
   $orig_url = $2;
   $text = $3;
   #print "$1\n";
   
   $text =~ s/\n/ /g;
   $text =~ s/http:\/\/.*?\s+/ /gi;
   $text =~ s/c\+\+/cplusplus/gi;
   $text =~ s/c#/chash/gi;
   #Modified on 02/14/04
   #Replace special characters with space
   $special_char_pat = "\,|_";
   $text =~ s/$special_char_pat/ /og;
   #$text =~ s/\-/ /g;
   #$text =~ s/^[-]?([!-].*)/$1/g;
   #$text =~ s/^[--]?([!-].*)/$1/g;
   $text =~ s/\bon site\b/onsite/gi;
   $text =~ s/\boff shore\b/offshore/gi;
   $text =~ s/\bon-site\b/onsite/gi;
   $text =~ s/\boff-shore\b/offshore/gi;
   #$text =~ s/\-/ /g;
   #$text =~ s/\./ /g;
   $text =~ s/\|/ /g;
   $text =~ s/mr\.|ms\.|mrs\.|dr\./ /gi;
   #$text =~ s/\://g;
   $text =~ s/\;/ /g;
   #$text =~ s/\(|\)//g;
   #$text =~ s/\'//g;
   #$text =~ s/\"//g;
   #$text =~ s/\*|\|//g;
   #$text =~ s/\`|\~|\!|\$|\%|\^|\&|\*|\+|\?|\[|\]|\{|\}|\.//g;
   $text =~ s/$stop_spec_char/ /og;
   $text =~ s/cplusplus/c\+\+/g;
    $text =~ s/\bchash\b/c#/g;
   #$text =~ s/site map|disclaimer/ /gi;
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

#added by T.Thaliath on 02/15/04 to remove invalid terms.
my (@newlst,$term,@tmp);

foreach $term(@lst)
{

   if ($term =~ /^[\\]$/){$j++;print OUT1 "$term\n";next;}
   if ($term =~ /^[\/]$/){$j++;print OUT1 "$term\n";next;}
   if ($term =~ /\.nsf.*?docid/i){$j++;print OUT1 "$term\n";next;}
   if ($term =~ /^[\\](.*)/)
     {
        $term = $1;
        #print "$term\n";
     }
   else
    {
    if ($term =~ /^[\/](.*)/)
     {
        $term = $1;
        #print "$term\n";
     } 
    }
   if ($term =~ /^\.+$/){$j++;print OUT1 "$term\n";next;}
   if ($term =~ /mm\/dd\/yyyy/i){$j++;print OUT1 "$term\n";next;}
   if ($term =~ /\/.*?\//){
    if ($term =~ /\d+\/\d+\/\d+/){$j++;print OUT1 "$term\n";next;}
    if ($term =~ /\.htm/i){$j++;print OUT1 "$term\n";next;}
    #@tmp = split(/\//,$term);
    $term = join('  ',split(/\//,$term));
    #print OUT2 "$term\n";
     }
   if ($term =~ /\\.*?\\/){$j++;print OUT1 "$term\n";next;}
   if ($term =~ /^nsf\//){$j++;print OUT1 "$term\n";next;}
   if ($term =~ /^[\-\-](.*)/)
     {
        $term = $1;
        #print "$term\n";
     }
   else
    {
    if ($term =~ /^[\-](.*)/)
     {
        $term = $1;
        #print "$term\n";
     } 
    }
   #$term =~ s/^[\-+]?([^\-].*)/$1/g;
#stem the term
   $term = stem($term);
   push (@newlst,$term);
}

$newtext = join(" ",@newlst);
$newtext =~ s/\d+?\.//g;
$newtext =~ s/\&/and/g;
print OUT "$url\n$newtext\n\n";
}

close (OUT);

close (OUT1);
close (OUT2);
#print "total invalid:$j\n";
exit 1;
