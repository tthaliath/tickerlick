#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: getsiterank.pl
#Date started : 10/19/03
#Last Modified : 10/19/03
#Purpose : update the site master file with rank

my($url,%ranklist,%loclist,$logrank);
#Open file1

open (FILE2,"com_rel_data1.txt");
while (<FILE2>){
chomp;
($id,$url,$desc,$rank) = split(/\t/,$_);
$rank =~ s/\,//g;
$ranklist{$id} = $rank;
#print "$id\$rank\n";
}
close(FILE2);
open (FILE3,"locationmaster.txt");
while (<FILE3>){
chomp;
($loc_id,$location) = split(/\t/,$_);
$loclist{$location} = $loc_id;
#print "$loc_id\$location\n";
}
close(FILE3);
open (OUT,">sitemaster.txt");
open (FILE1,"<siteallnew.txt");
while(<FILE1>)
{
 chomp;

 ($id,$url,$loc,$desc) = split(/\t/,$_);
  if ($ranklist{$id} == 0){print "$id\n";}
  if (!$loclist{$loc}){print "Location: $id\t$loclist{$loc}\n";}
  if (!$ranklist{$id}){print "Rank: $id\t$ranklist{$id}\n";}
  $logrank = sprintf("%.4f",log($ranklist{$id}));
  print OUT "$id\t$url\t$loclist{$loc}\t$desc\t$ranklist{$id}\t$logrank\n";

 
} # EOF WH#ILE LOOP
close(FILE1);
close(OUT);


exit 1;