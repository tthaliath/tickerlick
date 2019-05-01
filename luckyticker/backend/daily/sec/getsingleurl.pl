#!/usr/bin/perl
use LWP::Simple;
	$url = "https://www.sec.gov/Archives/edgar/data/1018724/000101872416000324/0001018724-16-000324.txt";
        $str = get($url);
         print "$str\n";




