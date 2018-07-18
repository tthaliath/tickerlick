#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: in10_stemmer3.pl
#Date started : 02/14/04
#Last Modified : 02/14/04
#Purpose : Read the contents of an index file, create a file with all words


#use strict;



my ($keyword,$key);
my ($page_id,$cnt);
my ($total,$links,%keyhash,$k,$rem,$tex,$temp);
my ($id,$category,$keystr,$clink,$texthtml,$dest_file);
my $data_dir = "index/" ;
my $fullname;
my $file;
my ($term);
my @sub_list;
my (%termhash,$termfirst,$termnext,$termlist);

sub stem
{  my ($stem, $suffix, $firstch);
   my $w = shift;
   $w =~ s/\\//g;
   if (length($w) <= 3) { return $w; } # length at least 3

   if ($w =~ /(us)es$/) { $w=$`.$1; }
   if ($w =~ /(ss)es$/) { $w=$`.$1; }
   if ($w =~ /hes$/) { $w=$`."h"; }
   if ($w =~ /([^siouy])s$/) { $w=$`.$1; }
   elsif ($w =~ /(eo)s$/) { $w=$`.$1; }
   #if ($w =~ /ing$/) { $w=$`; }
   if (length($w) > 4 && $w !~ /eed$/){
   if ($w =~ /^[a-z][aeiouy]ed$/) {return  $w; }
   if ($w =~ /ied$/) { $w=$`."y"; }
   elsif ($w =~ /([^us]se)d$/) {$w=$`.$1; }
   elsif ($w =~ /(ure)d$/) {$w=$`.$1; }
   elsif ($w =~ /(nce)d$/) { $w=$`.$1; }
   elsif ($w =~ /(s|y)ed$/) { $w=$`.$1; }
   elsif ($w =~ /(iate)d$/) { $w=$`.$1; }
   elsif ($w =~ /(ual)ed$/) { $w=$`.$1; }
   elsif ($w =~ /(uce)d$/) { $w=$`.$1; }
   elsif ($w =~ /([a-z]rol)led$/){$w=$`.$1;}
   elsif ($w =~ /([^lsdzf])(\1)ed$/){$w=$`.$1;}
   elsif ($w =~ /([lsdzf])(\1)ed$/){$w=$`.$1.$1;}
   elsif ($w =~ /(u[l|s]e)d$/) { $w=$`.$1; }
   elsif ($w =~ /([oe]r)ed$/) { $w=$`.$1; }
   elsif ($w =~ /(ve)d$/) { $w=$`.$1; }
   elsif ($w =~ /([aeioy][aeioy][^e])ed$/) {$w=$`.$1; }
   elsif ($w =~ /([aeioy][^e]e)d$/) {$w=$`.$1; }
   elsif ($w =~ /(ude)d$/) { $w=$`.$1; }
   elsif ($w =~ /(ocus)ed$/) { $w=$`.$1; }
   elsif ($w =~ /(le)d$/) { $w=$`.$1; }
   elsif ($w =~ /ed$/) { $w=$`; }
   } #removing ed
   if (length($w) <= 3) { return $w; }
   if ($w =~ /(ie)$/) { $w=$`."y"; }
  return $w;
}

# that's the definition. Run initialise() to set things up, then stem($word) to stem $word, as here:
my $spec_chars = '\#|\`|\~|\!|\$|\%|\^|\&|\*|\+|\?|\[|\]|\{|\}|\*|\"|\'|\(|\)|\:|<|>|\-|\_|\[|\]|\\|\/';



open (OUT,">termmasterstem.txt");

my $i = 0;
opendir (DIR, $data_dir) ;
while (defined($file = readdir(DIR))){
  if ($file =~ /\.txt/) {
    push (@sub_list,$file);
    
  }
}
closedir (DIR);
my $filename;
$k = 0;

my %keyhash = ();
foreach $filename(@sub_list)
{
 $i++;
 #print "$i\t$filename\n";
 $fullname = $data_dir.$filename;
 open (F,"<$fullname");
  while (<F>)
   {
     chomp;
      #print "$_\n";
      
     ($term,$fileid,$temp,$cnt,$links) = split (/\t/,$_);
     if ($term =~ /^[a-z|0-9|$spec_chars]+$/){
      $term = stem($term);
      #print "$term\t$fileid\t$cnt\n";
      if ($keyhash{$term})
         {
          #print "TERM:$term\n";
          $keyhash{$term} .= "k".$fileid."_".$links;}
      else
      {$keyhash{$term} = $fileid."_".$links};
      }
    }
    close(F);
   #if ($i > 49){last;}
   }

 my ($j) = 0;  
    foreach $term(sort keys %keyhash)
    {
    
      
         $j++;
         print OUT "$term\t$keyhash{$term}\n";
      }
    
close(OUT);
print "total terms:\t$j\n";


exit 1;


