#!/usr/bin/perl

open (F,"<pagerank_web.txt");
while (<F>){
chomp;
($id,$url,$desc,$rank) = split(/\t/,$_);
$rank =~ s/\,//g;
if ($rank !~ /\d+/){print "$id\t$url\n";}
#if ($rank > 1000) {print "$_\n";}
}
close (F);
