#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: cr07_removeduplink_linklist2.pl
#Date started : 01/31/04
#Last Modified : 01/31/04
#Purpose : Remove the duplicate link from the url file in linklist2 folder 
#--------------------------------------------------------------------------
#Modification History 
#Date : 
#	
#-------------------------------------------------------------------------
use strict ;


my $link_dir1 = "linklist1" ;
my $link_dir2 = "linklist2" ;
my $fullname;
my $file;
my $header;
my @sub_list;
my %subcounts = ();
my %aa;
my $i = 0;
my ($key);
my ($id,$url,$linktext,$linkid);
my ($idmain,$urlmain,$linktextmain);
#undef $/;
#system ("del sitelinklog.txt");
opendir (DIR, $link_dir1) ;
while (defined($
file = readdir(DIR))){
  if ($file =~ /\.txt/) {
    push (@sub_list,$file);
    
  }
}
closedir (DIR);
my $filename;
my $flag;
foreach $filename(@sub_list)
{
 $i++;
 #print "$i\t$filename\n";
 $fullname = "$link_dir1/$filename";
 open(IN,"$fullname");
 $flag = 0;
 
 while (<IN>)
 {
   chomp;
    ($id,$url,$linktext) = split(/\t/,$_);
    ($idmain,$urlmain,$linktextmain) = ($id,$url,$linktext);
     #print "MAIN:$idmain\t$urlmain\t$linktextmain\n";
    
    last;
 }
close (IN);

#Add main link to hash

#Let all the main links be hub and links extracted from main links are authoritatative.
my ($hub) = 0;
my $auth;

my %aa;
if (!$idmain){$id = $idmain;}
$linkid = "$idmain"."-1";
$aa{$urlmain} = "$linkid\t$urlmain\t$linktextmain\t$hub";
#Remove duplicate links

my $j = 1;
open (FH1,"$link_dir2/$filename");
while (<FH1>)
{

  chomp;
  ($id,$url,$linktext,$auth) = split (/\t/,$_);
  #if ($url !~ /^http/i){$url = "http://".$url;}

  if (!$aa{$url}){
  $j++;
  $linkid = "$idmain"."-"."$j";
  $aa{$url} = "$linkid\t$url\t$linktext\t$auth";
  }
}
close(FH1);

open (FH2,">$link_dir2/$filename");
foreach $key(keys (%aa))
{
  print FH2 "$aa{$key}\n";
}
close(FH2);
#print "$j unique links fetched\n";
open (NOLINK,">>urllinkdatarerun.txt");
print NOLINK "$idmain\t$urlmain\t$linktextmain\t$j\n";
close (NOLINK);
#if ($i > 0){last;}
}
print "$i files processed\n";
exit 1;
