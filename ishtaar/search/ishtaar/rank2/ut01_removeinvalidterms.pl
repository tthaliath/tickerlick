#!d:/perl/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: ut01_removeinvalidterms.pl
#Date started : 02/15/04
#Last Modified : 02/15/04
#Purpose : remove invalid terms


use Strict;

open(IN,"termmaster.txt");
open(OUT,">termmasternew.txt");
open(OUT1,">termmasterinvalid.txt");
my ($term,$cnt,$i);
$i = 0;
while (<IN>){
 chomp;

   ($term,$cnt) = split(/\t/,$_);
   if ($term !~ /^[a-z|0-9]/) {
   print OUT1 "$term\t$cnt\n";}
   else{
   $i++;
   print OUT "$term\t$cnt\n";
   }
}
print "total valid terms:$i\n";
close(IN);
close(OUT);
close(OUT1);
exit 1;