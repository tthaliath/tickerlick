#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: crawler1.pl
#Date started : 09/28/02
#Last Modified : 09/28/03
#Purpose : Read the contents of a URL from a text file, Extract all the links 
#(excluding redirect links) and store it in a file - used for get the resukts from 
# second list

my($url,%filelist);
#Open file1
open (FILE1,"<siteallnew.txt");
open (FILE2,"sitemasterlog1.txt");
while (<FILE2>){
chomp;
($id,$url) = split(/,/,$_);
$filelist{$id}++;
}
close(FILE2);
my $i = 0;
while(<FILE1>)
{
 chomp;

 ($id,$url,$loc,$desc) = split(/\t/,$_);
  #print "$id\t$url\n";
  if($filelist{$id}){
 ++$i;
 $filelist{$id} = "$url\t$desc";}
 #$url = lc $url;


if ($id == 784){
system("perl linkextr1.pl $id $url");
last;
}

#if ($i > 49){last;}
} # EOF WHILE LOOP
close(FILE1);

foreach $id(sort keys(%filelist)){
#print "$id\t$filelist{$id}\n";
}
print "$i url's processed";
exit 1;