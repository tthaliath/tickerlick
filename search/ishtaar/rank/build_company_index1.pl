#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: build_company_index1.pl
#Date started : 09/16/03
#Last Modified : 09/17/03
#Purpose : build an index of keywords(company names) using smart-inc data

use strict;
use LWP::Simple; 

my($url,$id,$key,$site,$newdesc,$filename,$desc);

$filename = "smartinc-india_index.txt";

my $data_dir = "d:/ishtaar/rank/linklist1/data" ;
#Open file1
open (FILE1,">>$filename");
open (FILE2,"<$data_dir/smartinc-india.txt");
undef $/;
my $text = <FILE2>;
close(FILE2);
$/ = "\n";
my $i = 0;
my (%hash,%company);
open (FILE3,"<newcompanydesc.txt");
while(<FILE3>)
{
 chomp;
 #print "$_\n";
  ($id,$site,$desc,$newdesc) = split(/\t/,$_);
   $newdesc =~ s/\{|\}|\[|\]|\-|\_|\(|\)//g;
   #print "$id\t$site\t$newdesc\n";
   $newdesc =~ s/{|}|[|]|-|_|(|)//g;
   $hash{$id} = 0;
   $company{$id} = "$desc\t$newdesc";
   while ($text =~ /$newdesc/gsi){$hash{$id}++;}
       
    $i++;
    #if ($i > 100) {last;}
}

print "no of rec:$i\n";
foreach $key(sort{$a <=> $b} keys(%hash))
{
   print "$key\t$company{$key}\t$hash{$key}\n";
}

close(FILE1);
close(FILE3);
exit 1;