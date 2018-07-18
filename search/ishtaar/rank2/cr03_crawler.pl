#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: cr03_crawler.pl
#Date started : 12/28/03
#Last Modified : 12/28/03
#Purpose : Read the URL from a text file , pass it extractor program 
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
  if ($file =~ /^oracle\.txt/) {
    push (@sub_list,$file);
    
  }
}
closedir (DIR);
my $filename;
my $flag;
foreach $filename(@sub_list)
{
 $i++;
 print "$i\t$filename\n";
 if (-e "$link_dir2/$filename"){next;}
#{print "$i $filename exists\n";next;}
 $fullname = "$link_dir1/$filename";
 open(IN,"$fullname");
 $flag = 0;
 
 while (<IN>)
 {
   chomp;
    ($id,$url,$linktext) = split(/\t/,$_);
    #print "test:$id\t$url\t$linktext\n";
    #if ($url !~ /^http/i){$url = "http://".$url;}
    
    if ($url =~ /contact/i) {next;}
    #if ($url =~ /article/i) {next;}
    #if ($url =~ /jobs/i) {next;}
    if ($url =~ /disclaimer/i) {next;}
    if ($url =~ /career/i) {next;}
    if ($url =~ /archive/i) {next;}
    if ($url =~ /feedback/i) {next;}
    #if ($url =~ /sitemap/i) {next;}
    if ($url =~ /download/i) {next;}
    if ($url =~ /testimonial/i) {next;}
    if ($url =~ /subscribe/i) {next;}
    #if ($url =~ /about/i) {next;}
    #if ($url =~ /search/i) {next;}
    if ($url =~ /legal/i) {next;}
    #if ($url =~ /news/i) {next;}
    if ($url =~ /map\./i) {next;}
    if ($url =~ /login\./i) {next;}
    if ($url =~ /^http:\/\/sitefinder\.verisign\.com/i){next;}
    $url =~ s/\/\.\.\//\//g;
    if (!$flag) {  #read the first line to get company info. and id
    ($idmain,$urlmain,$linktextmain) = ($id,$url,$linktext);
     #print "MAIN:$idmain\t$urlmain\t$linktextmain\n";
     if(!$linktextmain){$linktextmain = "MAIN";}
    open(TMP,">>sitelinklog.txt");
    
    print TMP "$_\n";
    close(TMP);
    $flag = 1;
   }
   else{
 
   #print "$url\n";
   #if ($id == 1279){
   system("perl cr04_linkextr.pl $filename $id $url \"$linktext\"");
  # }
   }
#last;
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
open (NOLINK,">>urllinkdata2.txt");
print NOLINK "$idmain\t$urlmain\t$linktextmain\t$j\n";
close (NOLINK);
#if ($i > 0){last;}
}
print "$i files processed\n";
exit 1;
