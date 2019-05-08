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
$base_link1 = "http://www.google.com/search?as_q=&num=10&hl=en&ie=ISO-8859-1&btnG=Google+Search&as_epq=";
$base_link2 = "&as_oq=&as_eq=&lr=&as_ft=i&as_filetype=&as_qdr=all&as_nlo=&as_nhi=&as_occt=any&as_dt=i&as_sitesearch=&safe=images";

$newdesc = "mphasis";
$newdesc =~ s/\s+/\+/g;
$newdesc =~ s/(.*)\+$/$1/g;
$full_url = $base_link1.$newdesc.$base_link2;
print "$full_url\n\n\n";
$text = get $full_url;
print "$text\n";


