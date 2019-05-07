#!/usr/bin/perl
use LWP::Simple;
$url = "http://finance.yahoo.com/q?s=aame";
$res = get ($url);
print "$res\n";

