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
my $data_dir = "clipper/" ;
my $fullname;
my $file;
my ($pat,$catid);
my @sub_list;
my (%termhash,$termfirst,$termnext,$termlist,%termnexthash,$firmid,$termtot);
$termtot = 0;
open (IN,"termmasternew.txt");
#open (IN,"1term.txt");
system("del indextermurl.txt");
while (<IN>){
  chomp;
  ($keystr) = split(/\t/,$_);
   if ($keystr =~ /\+/){$keystr =~ s/\+/\\\+/g;}
  if ($keystr =~ /^\d+/){next;}
  $termhash{$keystr}++;
  
}
close (IN);
my $i = 0;
opendir (DIR, $data_dir) ;
while (defined($file = readdir(DIR))){
  if ($file =~ /\.txt/) {
     #print "$file\n";
    push (@sub_list,$file);
    
  }
}
closedir (DIR);
my $filename;
$k = 0;
foreach $term (sort keys(%termhash))
{

open (OUT, ">>indextermurl.txt");


$termtot++;
print "$termtot\t$term\n";
%keyhash = ();
foreach $filename(@sub_list)
{
 $i++;
 #print "$i\t$filename\n";
 $fullname = $data_dir.$filename;
 
 undef $/;
 open (F,"<$fullname");
 $text = <F>;
 close(F);
 $/ = "\n";


#print "TERM:$term\n";
 
   while ($text =~ /(.*)?\t\thttp:\/\/.*?\n(.*?)\n\n/mgi)
   {
   $clink = $1;
   #print "$clink\n";
   $texthtml = $2;
   
   if ($texthtml !~ /\s$term\s/){
     #print "nolink:$clink\n";
     next;}   
   while ($texthtml =~ /.*?\s$term\s(.*?)\s/gs){
    #print "next:$clink:$1\n"; 
    #if ($1 !~ /\s+/){
     #if ($term == 'c\+\+'){print "C++:$1\n";}
     $keyhash{$1}++;
    #}
    }
   }
   }
   #print "FFFFFFFFFFFFFFFFFFFFFFFF\n";
   $termlist = '';
   $i = 0;
    foreach $termnext(sort{$keyhash{$b} <=> $keyhash{$a}} keys(%keyhash))
    #foreach $termnext(keys(%keyhash))
    {
      $i++;
      #print "PRINT:$term\t$termnext\n";
      if ($termnext !~ /c\+\+/){$termlist .= $termnext.'|';}
   
    if ($i > 19)
    {
     last;
    }
   
  }
  $termlist =~ s/^(.*)\|/$1/g;
  #$termlist =~ s/\|c\+\+//g;
  #$termlist =~ s/\|vc\+\+//g;
  #print "$term\t$termlist\n";
  %termnexthash = ();
 $i = 0;
  foreach $filename(@sub_list)
{
 $i++;
 #print "$i\t$filename\n";
 $fullname = $data_dir.$filename;
 
 undef $/;
 open (F,"<$fullname");
 $text = <F>;
 close(F);
 $/ = "\n";
  while ($text =~ /((.*?)\-.*?)\t\thttp:\/\/.*?\n(.*?)\n\n/mgi)
     {
     $firmid = $2;
     $clink = $1;
     $texthtml = $3;
    
     while ($texthtml =~ /.*?\s($termlist)\s/gs){
      #print "$clink";
      #($firmid) = split(/\-/,$clink);
      #print "LINK:$clink\tFIRM:$firmid\n";
      $termnexthash{$1}{$clink}++;
      }
     }
  } 
  
 
  my (%termhashlink) = ();
  my ($fileidlist);
  foreach $termnext(sort keys(%termnexthash))
  {
    $fileidlist = '';
    %termhashlink = %{$termnexthash{$termnext}};
     $i = 0;
    foreach $fileid (sort{$termhashlink{$b} <=> $termhashlink{$a}} keys (%termhashlink ))
    {
      $i++;
     if ($i > 19){last;}
     $fileidlist .= $fileid.'*'.$termhashlink{$fileid}.',';
    }
    print  OUT "$term\t$termnext\t$fileidlist\n\n";

   }
close(OUT);
}





                           
exit 1;


