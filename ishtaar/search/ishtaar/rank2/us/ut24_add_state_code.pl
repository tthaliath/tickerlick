#!/usr/bin/perl


my (%hash,$key);
open (CODE,"<statecode.txt");
while (<CODE>)
{
  chomp;
  my ($a,$b) = split (/\t/,$_);
  $hash{$b}=$a;
}
close (CODE);
open (OUT,">us_state_metro_desc_master.txt");
open (F,"<us_state_metro_master.txt");
while (<F>)
{
   chomp;
   my ($id,$state,$metro) = split (/\t/,$_);
  $metrodesc = $metro;
  $metrodesc =~ s/_/ /g;
  $metrodesc = $hash{$state}."-".$metrodesc;
  print OUT "$id\t$hash{$state}\t$state\t$metro\t$metrodesc\n";
}
close(OUT);
close(F);

1; 
      
