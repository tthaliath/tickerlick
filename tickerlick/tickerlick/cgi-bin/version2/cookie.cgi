#!/usr/bin/perl
use CGI;
$q  = new CGI;
%cookies = $q->cookie();
print $q->header;
print $q->start_html('ffffffffffffffffffffff');;
foreach $key (keys %cookies)
{
    print '<h2>'.$key.':'.$cookies{$key}.'</h2>';
}
print $q->end_html;
1;


