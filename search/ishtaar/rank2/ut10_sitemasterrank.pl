#!/usr/bin/perl

use strict;
my ($id,$url,$desc,$rank,$size,$loc,$locid,$firm,$filename,%lochash,%rankhash);
my ($rank,$logrank);
open (F,"<pagerank_web1.txt");
while (<F>){
chomp;
($id,$url,$desc,$rank) = split (/\t/,$_);
$rank =~ s/\,//g;
if ($rank !~ /\d+/){print "$_\n";}
$rankhash{$id} = $rank;
}
close (F);
open (LOC,"<locationweb.txt");
while (<LOC>){
chomp;
($locid,$loc) = split (/\t/,$_);
$lochash{lc $loc} = $locid;
}
close (LOC);

open (OUT,">sitemasterrank1.txt");
open (SITE, "<sitemaster1.txt");
while (<SITE>){
chomp;
($id,$url,$loc,$desc,$size,$firm,$filename) = split(/\t/,$_);
 $rank = $rankhash{$id};
if (!$filename){
 print "$id\t$url\t$loc\t$desc\t$size\t$firm\t$filename\n";
}
 if ($rank == 0){$rank = 1;}
 $logrank = sprintf("%.4f",log($rankhash{$id})); 
 #add country code to filename
 $filename = $filename.'in';
 print OUT "$id\t$url\t$desc\t$loc\t$filename\t$lochash{$loc}\t$rank\t$logrank\t$size\n"; 
}
close (SITE);
close (OUT);
