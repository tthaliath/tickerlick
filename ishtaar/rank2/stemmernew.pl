#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: ut15_stemmer.pl
#Date started : 09/10/04
#Last Modified : 09/10/04
#Purpose : stem a word

use strict;
sub stem
{  my ($stem, $suffix, $firstch);
   my $w = shift;
   $w =~ s/\\//g;
   if (length($w) <= 3 || $w =~ /xed$/) { return $w; }
   if ($w =~ /(us)es$/) { $w=$`.$1; }
   if ($w =~ /(ss)es$/) { $w=$`.$1; }
   if ($w =~ /(hes)$/) { $w=$`."h"; }
   if ($w =~ /([^siouy])s$/) { $w=$`.$1; }
   elsif ($w =~ /(eo)s$/) { $w=$`.$1; }
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
1;
