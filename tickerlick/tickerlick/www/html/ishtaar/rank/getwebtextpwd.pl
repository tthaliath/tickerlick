#!d:\per\bin\perl -w
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: getwebtextpwd.pl
#Date started : 09/16/03
#Last Modified : 09/16/03
#Purpose : Extract text from web page
#--------------------------------------------------------------------------
#Modification History 
#Date : 03/28/03
#	
#-------------------------------------------------------------------------
use strict ;

my ($base_link,$full_url);

$base_link = "http://www.google.com/search?hl=en&ie=UTF-8&oe=UTF-8&q=broadcom+india";
#$base_link = "http://search.yahoo.com/search?x=op&vp=Sysnet+Associates&vp_vt=any&vst=0&vd=all&fl=0&ei=UTF-8&vm=r&n=20";
my ($url) = $base_link;
$full_url = $url;

my ($edition) = "BT International(Web Edition)";
my ($bt) = "20030914/cover1.html";
my ($sub_id) = "BTW00-t5032-5932";
my ($submit) = "Read Now";

use HTTP::Request::Common "POST";


my $ua = new LWP::UserAgent;
$ua=>redirect_ok { 1 };
my $req = POST 'http://www.business-today.com/btoday/20030914/btsubscription.phtml',
     [ edition => 'BT',
       BT=> '20030914/cover1.html',
       sub_id => 'BTW00-t5032-5932',
       Submit => 'Read Now'
     ];
my $content = $ua->request($req)->as_string;
print "$content\n";
exit 1;
