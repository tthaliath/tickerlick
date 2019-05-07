#!d:/perl/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: removeduplink.pl
#Date started : 06/05/03
#Last Modified : 09/16/03
#Purpose : remove duplicate links
$httpdir="d:/ishtaar/rank/linklist1";
#Get the file name from command argument.
my ($file) =  @ARGV;
my ($id,$url);
print "$file\n";
open(IN,"$httpdir/$file");


my %aa = ();
while (<IN>){
 chomp;

   ($id,$url) = split(/\t/,$_);
   if (!$aa{$url}){$aa{$url} = $id;}

}

close(IN);

open(OUT,">$httpdir/$file");
foreach $url(sort{$aa{$a} <=> $aa{$b}} keys %aa)
{

  print OUT "$aa{$url}\t$url\n";
}
close(OUT);
exit 1;