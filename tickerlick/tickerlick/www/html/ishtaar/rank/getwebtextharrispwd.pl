#!/usr/bin/perl
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
use LWP;
use HTTP::Request;
my ($base_link,$full_url);

my ($url) = $base_link;
$full_url = $url;

my ($txtUserName) = "thaliath";
my ($bt) = "20030914/cover1.html";
my ($txtPassword) = "dimple";
my ($submit) = "Read Now";

use HTTP::Request::Common "POST";


my $ua = new LWP::UserAgent;
#$ua=>redirect_ok { 1 };
my $req = POST 'http://www.companyreach.com/CompanyInsight/SearchPages/CompanyProfile.aspx?actId=8129607',
     [ txtUserName => 'thalaith',
       txtPassword => 'dimple'
     ];
my $content = $ua->request($req)->as_string;
print "$content\n";
exit 1;
