#!/usr/bin/perl

$url = "http://www.intensedesigns.net/";

$orig_url = $url;
$url=~s#^http://##gi;               # strip off http://
$url=~s/(.*)#.*/$1/;
$url=~s#^([^/]+).*#$1#;   # everything before first / is domain
print "$url\n";
if ($url =~ /.*?\.(.*?)\.(.*)/){
$domain_name = lc $1;
$rest = lc $2;
$cname = $domain_name.$rest;
$cname =~ s/\.//g;
print "$cname\n";
}
