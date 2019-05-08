#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: company_desc.pl
#Date started : 09/15/03
#Last Modified : 09/15/03
#Purpose : Read the master company file and get a meaningful description of the company.

use strict;

my($id,$url,$loc,$cdesc,$site,$newdesc);
#Open file1
open (FILE1,"<siteall.txt");
open (FILE2,">newcompanydesc.txt");
my %desc = {};
my $stopword  = 'ltd\.|limited|pvt\.|private';
while(<FILE1>)
{
 chomp;
 ($id,$url,$loc,$cdesc) = split(/\t/,$_);
 $url =~ /.*?\.(.*?)\.(.*)/;
 $site = $1;
 #if ($cdesc =~ /(.*?)\s+[ltd\.|limited|pvt\.|private|inc\.]/i)

#{
#    $cdesc = $1;
#}
 if ($cdesc !~ /\s+/){
  $newdesc = $cdesc;
}
 else
 {
 if ($cdesc =~ /(.*?\s+.*?)\s+/)
 {
 $newdesc = $1;
 
 }
 else
 {
   $newdesc = $cdesc;
   #print "$newdesc\n";
 }
}

print "$newdesc\n";
if ($newdesc =~ /(.*?)\s+[ltd\.|limited|pvt\.|private|inc\.]$/i)

{
    #print "$newdesc\n";
    $newdesc = $1;
}
$desc{$newdesc}++;
print FILE2 "$id\t$site\t$cdesc\t$newdesc\n";




} # EOF WHILE LOOP
close(FILE1);
close(FILE2);
exit 1;