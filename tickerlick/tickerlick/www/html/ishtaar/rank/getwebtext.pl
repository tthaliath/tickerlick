#!d:\per\bin\perl -w
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: getwebtext.pl
#Date started : 03/28/03
#Last Modified : 09/15/03
#Purpose : Fetch the web page text for given URL
#--------------------------------------------------------------------------
#Modification History 
#	
#-------------------------------------------------------------------------
use strict ;
use LWP::Simple; 


my ($base_link,$full_url);

#$base_link = "http://www.infosys.com/";
$base_link = "http://dir.yahoo.com/Regional/U_S__States/Alabama/Metropolitan_Areas/";
#$base_link = "http://search.yahoo.com/search?x=op&vp=Sysnet+Associates&vp_vt=any&vst=0&vd=all&fl=0&ei=UTF-8&vm=r&n=20";
my ($url) = $base_link;
$full_url = $url;


my $text = get $full_url;
if ($text)
{
print "$text\n";
}
exit 1;
