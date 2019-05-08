#!/usr/bin/perl

open (F,"<siteallnew2.txt");
open (OUT,">siteallnew3.txt");
my ($temprec);
while (<F>){
chomp;
($id,$url,$loc,$desc,$size) = split(/\t/,$_);
if ($id =~ /\d+/){
if ($temprec){print OUT "$temprec\n";}
$temprec = $_;}
else
{$temprec .= " ".$_;}
}
close (F);
close (OUT);
