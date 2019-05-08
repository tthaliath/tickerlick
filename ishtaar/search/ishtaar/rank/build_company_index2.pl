#!d:\per\bin\perl -w
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: build_company_index2.pl
#Date started : 09/17/03
#Last Modified : 09/17/03
#Purpose : Fetch the web page for the given search word and get the no.
# of results
#--------------------------------------------------------------------------
#Modification History 
#	
#-------------------------------------------------------------------------
use strict ;
use LWP::Simple; 


my ($base_link1,$full_url,$newdescorig,$base_link2,$numid,$text);
my ($id,$site,$desc,$newdesc);
my ($i) = 0;
$base_link1 = "http://search.yahoo.com/search?x=op&vp=";
$base_link2 = "&vp_vt=any&vst=0&vd=all&fl=0&ei=UTF-8&vm=r&n=20";

open (F,"newcompanydesc.txt");
while (<F>)
{
chomp;
($id,$site,$desc,$newdesc) = split(/\t/,$_);
$newdescorig = $newdesc;
$newdesc =~ s/\s+/\+/g;
$newdesc =~ s/(.*)\+$/$1/g;
$full_url = $base_link1.$newdesc.$base_link2;
#print "$full_url\n";
$i++;
$numid = ord($id);
if ($id > 1749 && $id <= 1800){
$text = get $full_url;
if ($text)
{
open (OUT,">>com_rel_data1.txt");
#print "$text\n";
$text =~ /.*?out of about\s+?([\d|\,]+)\b/;
#$i++;
print OUT "$id\t$site\t$newdescorig\t$1\n";
close(OUT);
}
}
#if ($id > 17){last;}
}
close(F);
exit 1;