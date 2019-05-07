#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: in05_indextermbyurl.pl
#Date started : 02/14/04
#Last Modified : 02/14/04
#Purpose : Read the contents of an index file, create nextword index


use strict;
#use DB_File;
my ($keyword,$key);
my ($page_id,$cnt);
my ($total,$links,%keyhash,$k,$rem,$text,$fileid);
my ($id,$category,$keystr,$clink,$texthtml,$dest_file,$term);
my $data_dir = "d:/ishtaar/rank2/clipper/" ;
my $fullname;
my $file;
my ($pat,$catid);
my @sub_list;
my (%termhash,$termfirst,$termnext,$termlist,%termnexthash);

open (IN,"termmasternew.txt");

while (<IN>){
  chomp;
  ($keystr) = split(/\t/,$_);
   if ($keystr =~ /\+/){$keystr =~ s/\+/\\\+/g;}
  $termhash{$keystr}++;
}
close (IN);
my $i = 0;
opendir (DIR, $data_dir) ;
while (defined($file = readdir(DIR))){
  if ($file =~ /^info.*\.txt/) {
     print "$file\n";
    push (@sub_list,$file);
    
  }
}
closedir (DIR);
my $filename;
$k = 0;
foreach $term (sort keys(%termhash))
{
print "$term\n";
open (OUT, ">indextermurl.txt");
#print "$term\n";
if ($term =~ /^\d+/){next;}
foreach $filename(@sub_list)
{
 #$i++;
 #print "$i\t$filename\n";
 $fullname = $data_dir.$filename;
 
 undef $/;
 open (F,"<$fullname");
 $text = <F>;
 close(F);
 $/ = "\n";

%keyhash = ();
#print "TERM:$term\n";
 
   while ($text =~ /(.*)?\t\thttp:\/\/.*?\n(.*?)\n\n/mgi)
   {
   $clink = $1;
   #print "$clink\n";
   $texthtml = $2;
   
   
   while ($texthtml =~ /.*?\s$term\s(.*?)\s/gs){
    #print "$1\n"; 
    $keyhash{$1}++;
    }
   }
   }
   
   $termlist = '';
   $i = 0;
    #foreach $termnext(sort{$keyhash{$b} <=> $keyhash{$a}} keys(%keyhash))
    foreach $termnext(keys(%keyhash))
    {
      $i++;
      #print "$term\t$termnext\n";
      $termlist .= $termnext.'|';
   
    #if ($i > 9)
    #{
     #last;
    #}
   
  }
  $termlist =~ s/^(.*)\|/$1/g;
  #print "$term\t$termlist\n";
  %termnexthash = ();
  while ($text =~ /(.*?)\t\thttp:\/\/.*?\n(.*?)\n\n/mgi)
     {
     $clink = $1;
     $texthtml = $2;
    
     while ($texthtml =~ /.*?\s($termlist)\s/gs){
      #print "$clink";
      $termnexthash{$1}{$clink}++;
      }
     }
   
  my (%termhashlink) = ();
  my ($fileidlist);
  foreach $termnext(sort keys(%termnexthash))
  {
    $fileidlist = '';
    %termhashlink = %{$termnexthash{$termnext}};
    foreach $fileid (keys (%termhashlink ))
    {$fileidlist .= $fileid.'*'.$termhashlink{$fileid}.',';}
    print  OUT "$term\t$termnext\t$fileidlist\n";

   }
close(OUT);
}





                           
exit 1;


