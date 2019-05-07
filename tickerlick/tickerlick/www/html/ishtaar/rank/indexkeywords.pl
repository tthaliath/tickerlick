#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: indexkeywords.pl
#Date started : 06/25/03
#Last Modified : 10/09/03
#Purpose : Read the contents of a text file, index word excluding categories.

use strict;
#my ($id,$category,@keylist,$keystr,$pat,$value);
my $filename = $ARGV[0];
my $clipper_dir = "d:/ishtaar/rank/clipper/" ;
my $index_dir = "d:/ishtaar/rank/index/";
my $dest_name = $index_dir.$filename;
$filename = $clipper_dir.$filename;
undef $/;
open (F,"<$filename");

my $text = <F>;
close(F);
$/ = "\n";
#print "$dest_name\n";
if (!$text){print "$filename size is zero\n";exit 1;}
open (OUT,">$dest_name");
&buildindex(\$text);
close(OUT);
exit 1;


sub buildindex(){
my $text = shift;
my %keyhash;
my $key;
my ($id,$category,$keystr,$url,$texthtml);

my (@wordlist,$word,$no_occur);
#print "$$text\n";
#open (F,"<keywords.txt");
#my $pat = <F>;
#close (F);
  #print "$pat\n";
  #$pat = lc $pat;
  my($pos);
  my ($clink);
  my ($stop_word) = 'whenever|however|how|it|its|par|ex|etc|government|participa|whose|wholly|within|without|year|whereever|whatever|among|pdf|about|ceo|cfo|coo|president|chairman';
  #my ($stop_spec_char) = '\=';
  while ($$text =~ /^(\d+-\d+)\t(http:\/\/.*?)\n(.*?)\n\n/mgi)
{
   $clink = $1;
   $url = $2;
   $texthtml = $3;
  if ($url =~ m/\.doc/i){next;}
  if ($url =~ m/\.jp/i){next;}
  if ($url =~ m/\.nsf/i){next;}
  if ($url =~ m/\.tif/i){next;}
  if ($url =~ m/\.ttf/i){next;}
  if ($url =~ m/\.swf/i){next;}
  if ($url =~ m/\.wmf/i){next;}
  if ($url =~ m/\.wrf/i){next;}
  if ($url =~ m/\.taf/i){next;}
  #$texthtml =~ s/\s+($pat)\s+/ /g;
  $texthtml =~ s/mr\.|ms\.|mrs\.|dr\./ /gi;
  #$texthtml =~ s/\s+\.//gis;
  my @wordlist = split(/\s+/,$texthtml);
  $pos = 0;
  %keyhash = ();
  foreach $word(@wordlist)
  {
   $word =~ s/(.*)\.$/\1/;
   #$word =~ s/\.([^\.].*)/\1/;
   #$word =~ s/\s+//g;
   #$word =~ s/\W+//g;
   if ($word =~ /\=/){next;}
   if ($word =~ /^\#/){next;}
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
   $pos++;
   #stemming. Make all the plural words singular
   #if ($word =~ /.*ies$/)
    #{
     # if ($word =~ /(.*)s$/)
     #   {
      #    $word = $1;
      #  }
   #}
   if ($keyhash{$word}){
    $keyhash{$word} .= ",".$pos;
   }
   else
   { $keyhash{$word} .= $pos;}
  }
  foreach $key(sort keys(%keyhash)){
   $no_occur = split(/,/,$keyhash{$key});
   print OUT "$key\t$clink\t$no_occur\t$keyhash{$key}\n";
  }
}


}