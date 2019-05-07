#!/usr/bin/perl

use LWP::UserAgent;
 
 my $ua = LWP::UserAgent->new;
 $ua->timeout(10);
 $ua->env_proxy;
 
 my $response = $ua->get('http://tickerlick.com/cgi-bin/gettickerdataone.cgi?q=aapl&s=Search');
 
 if ($response->is_success) {
     print $response->decoded_content;  # or whatever
     
 }
 else {
     die $response->status_line;
 }
