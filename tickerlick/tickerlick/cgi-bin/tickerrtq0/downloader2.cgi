#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
#use CGI::Carp qw(fatalToBrowser);

$|=1;

my $cgi = new CGI;
my $file = "macd.csv";
open (FILE, "</home/tthaliath/perltest/bull/bull-535-2013-04-25.csv");
print $cgi->header("application/octet-stream");
print $cgi->header("attachment;filename=$file");
print while(<FILE>);
close FILE;

