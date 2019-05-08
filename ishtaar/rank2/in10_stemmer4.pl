#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: in10_stemmer1.pl
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

local %step2list;
local %step3list;
local ($c, $v, $C, $V, $mgr0, $meq1, $mgr1, $_v);


sub stem
{  my ($stem, $suffix, $firstch);
   my $w = shift;
   if (length($w) < 3) { return $w; } # length at least 3
   # now map initial y to Y so that the patterns never treat it as vowel:
   $w =~ /^./; $firstch = $&;
   if ($firstch =~ /^y/) { $w = ucfirst $w; }

   # Step 1a
   if ($w =~ /(ss|i)es$/) { $w=$`.$1; }
   elsif ($w =~ /([^s])s$/) { $w=$`.$1; }
   # Step 1b
   if ($w =~ /eed$/) { if ($` =~ /$mgr0/o) { chop($w); } }
   elsif ($w =~ /(ed|ing)$/)
   {  $stem = $`;
      if ($stem =~ /$_v/o)
      {  $w = $stem;
         if ($w =~ /(at|bl|iz)$/) { $w .= "e"; }
         elsif ($w =~ /([^aeiouylsz])\1$/) { chop($w); }
         elsif ($w =~ /^${C}${v}[^aeiouwxy]$/o) { $w .= "e"; }
      }
   }
   # Step 1c
   if ($w =~ /y$/) { $stem = $`; if ($stem =~ /$_v/o) { $w = $stem."i"; } }

   # Step 4

   if ($w =~ /(al|ance|ence|er|ic|able|ible|ant|ement|ment|ent|ou|ism|ate|iti|ous|ive|ize)$/)
   { $stem = $`; if ($stem =~ /$mgr1/o) { $w = $stem; } }
   elsif ($w =~ /(s|t)(ion)$/)
   { $stem = $` . $1; if ($stem =~ /$mgr1/o) { $w = $stem; } }


   #  Step 5

   if ($w =~ /e$/)
   { $stem = $`;
     if ($stem =~ /$mgr1/o or
         ($stem =~ /$meq1/o and not $stem =~ /^${C}${v}[^aeiouwxy]$/o))
        { $w = $stem; }
   }
   if ($w =~ /ll$/ and $w =~ /$mgr1/o) { chop($w); }

   # and turn initial Y back to y
   if ($firstch =~ /^y/) { $w = lcfirst $w; }
   return $w;
}

sub initialise {

   %step2list =
   ( 'ational'=>'ate', 'tional'=>'tion', 'enci'=>'ence', 'anci'=>'ance', 'izer'=>'ize', 'bli'=>'ble',
     'alli'=>'al', 'entli'=>'ent', 'eli'=>'e', 'ousli'=>'ous', 'ization'=>'ize', 'ation'=>'ate',
     'ator'=>'ate', 'alism'=>'al', 'iveness'=>'ive', 'fulness'=>'ful', 'ousness'=>'ous', 'aliti'=>'al',
     'iviti'=>'ive', 'biliti'=>'ble', 'logi'=>'log');

   %step3list =
   ('icate'=>'ic', 'ative'=>'', 'alize'=>'al', 'iciti'=>'ic', 'ical'=>'ic', 'ful'=>'', 'ness'=>'');


   $c =    "[^aeiou]";          # consonant
   $v =    "[aeiouy]";          # vowel
   $C =    "${c}[^aeiouy]*";    # consonant sequence
   $V =    "${v}[aeiou]*";      # vowel sequence

   $mgr0 = "^(${C})?${V}${C}";               # [C]VC... is m>0
   $meq1 = "^(${C})?${V}${C}(${V})?" . '$';  # [C]VC[V] is m=1
   $mgr1 = "^(${C})?${V}${C}${V}${C}";       # [C]VCVC... is m>1
   $_v   = "^(${C})?${v}";                   # vowel in stem

}

sub stemnew
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



initialise();

open (OUT,">termmasterstem1.txt");

my $i = 0;
opendir (DIR, $data_dir) ;
while (defined($file = readdir(DIR))){
  if ($file =~ /^ambernetworks\.txt/) {
    push (@sub_list,$file);
    
  }
}
closedir (DIR);
my $filename;
$k = 0;

my %keyhash = ();
my($termnew);
foreach $filename(@sub_list)
{
 $i++;
 print "$i\t$filename\n";
 $fullname = $data_dir.$filename;
 open (F,"<$fullname");
  while (<F>)
   {
     chomp;
      #print "$_\n";
     ($term,$fileid,$temp,$cnt,$links) = split (/\t/,$_);
     if ($term =~ /^[a-z|0-9|$spec_chars]+$/){
      $termnew = stemnew($term);
      #if (length($termnew) != length($term) && $term =~ /[^l]ed$/){ 
     # $j++;
      print OUT "$term\t$termnew\n";
     # }

     
    }
  }
    close(F);
   #if ($i > 49){last;}
   }

    
close(OUT);
print "total terms:\t$j\n";



exit 1;


