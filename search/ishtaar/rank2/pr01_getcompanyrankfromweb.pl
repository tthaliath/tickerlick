#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: build_company_index2.pl
#Date started : 09/17/03
#Last Modified : 09/17/03
#Purpose : Fetch the web page for the given search word and get the no.
# of results
#--------------------------------------------------------------------------
#Modification History 
#-------------------------------------------------------------------------
use strict ;
use LWP::Simple; 


my ($base_link1,$full_url,$newdescorig,$base_link2,$numid,$text);
my ($id,$site,$desc,$newdesc,%crawled);
my ($i) = 0;
$base_link1 = "http://search.yahoo.com/search?x=op&vp=";
$base_link2 = "&vp_vt=any&vst=0&vd=all&fl=0&ei=UTF-8&vm=r&n=20";
open (CRAWLED1,"<crawled.txt");
while (<CRAWLED1>){chomp; $crawled{$_}++;}
close (CRAWLED1);
open (NORANK,">>norank.txt");
open (F,"newcompanydesc.txt");
while (<F>)
{
chomp;
($id,$site,$desc,$newdesc) = split(/\t/,$_);
if ($crawled{$id}){next;}
$newdescorig = $newdesc;
$newdesc =~ s/\s+/\+/g;
$newdesc =~ s/(.*)\+$/$1/g;
$full_url = $base_link1.$newdesc.$base_link2;
print "$id\n";
$i++;
#if ($id > 1749 && $id <= 1800){
$text = get $full_url;
if ($text)
{
open (OUT,">>pagerank_web.txt");
#print "$text\n";
$text =~ /.*?of about <strong>(.*?)<\/strong>/;
my $cnt = $1;
if (!$cnt){print NORANK "$id\t$site\t$newdescorig\t$1\n";}
print OUT "$id\t$site\t$newdescorig\t$1\n";
close(OUT);
open (CRAWLED,">>crawled.txt");
print CRAWLED "$id\n";
close(CRAWLED);		
}
else{print "NO TEXT:$id\t$site\$newdesc\n";} 
#}
#last;
#if ($id > 17){last;}
}
close(F);
close (NORANK);
close(CRAWLED);
exit 1;
