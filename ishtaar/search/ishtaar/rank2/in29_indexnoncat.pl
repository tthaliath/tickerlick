#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: in02_indexwords.pl
#Date started : 02/10/04
#Last Modified : 02/10/04
#Purpose : Read the contents of a text file, index words

use strict;
#require "ut15_stemmer.pl";
#my ($id,$category,@keylist,$keystr,$pat,$value);
my $filename = $ARGV[0];
my $clipper_dir = "clipper1/" ;
my $index_dir = "indexkey/";
my $dest_name = $index_dir.$filename;
$filename = $clipper_dir.$filename;
undef $/;
open (F,"<$filename");

my $text = <F>;
close(F);
$/ = "\n";
#print "$dest_name\n";
if (!$text){#print "$filename size is zero\n";
exit 1;}
open (OUT,">$dest_name");
&buildindex(\$text);
close(OUT);
exit 1;


sub buildindex(){
my $text = shift;
my %keyhash;
my $key;
my ($id,$category,$keystr,$url,$texthtml);
undef $/;
open (CAT,"<cat_pat.txt");
my $pat = <CAT>;
close(CAT);
#print "$pat\n";
$/ = "\n";
my (@wordlist,$word,$no_occur);
  $pat = lc $pat;
  my($pos);
  my ($clink);
  my ($stop_word) = 'whenever|however|how|it|its|par|ex|etc|participa|whose|wholly|within|without|year|whereever|whatever|among|pdf|about';
  #my ($stop_spec_char) = '\=';
  while ($$text =~ /(.*?)?\t(http:\/\/.*?)\n(.*?)\n\n/mgi)
{
   $clink = $1;
   $url = $2;
   $texthtml = $3;
  my $newtext = '';
  my @wordlist = split(/\s+/,$texthtml);
  %keyhash = ();
  $newtext = '';
  foreach $word(@wordlist)
  {
   
   $word =~ s/(.*)\.$/\1/;
   #$word =~ s/\.([^\.].*)/\1/;
   #$word =~ s/\s+//g;
   #$word =~ s/\W+//g;
   if ($word =~ /\=/){next;}
   #if ($word =~ /^\#/){next;}
   if ($word =~ /^\d+$/){next;}
   if ($word =~ /^\s+$/){next;}
   if ($word =~ /^\-+$/){next;}
   if ($word =~ /^\$/){next;}
   if ($word =~ /^.{1}?$/){next;}
   if ($word =~ /$stop_word/o){next;}
   if ($word =~ /^HASH/){next;}
   #if ($word =~ /$stop_spec_char/){next;}
   #if ($word =~ /^[\s|\W]+$/){next;}
   if (!$word){next;}
   #stemming. Make all the plural words singular
   #$word = stem($word);
   $newtext .= $word." ";
  }
  while ($newtext =~ /($pat)/sg){
     $keyhash{$1}++;
     }
    foreach $key(keys(%keyhash)){
     print OUT "$key\t$clink\t$keyhash{$key}\n";
  }
 
  #last; 
}


}

exit 1;

