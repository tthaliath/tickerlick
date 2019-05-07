#!/usr/bin/perl
use lib qw(/home/tickerlick/cgi-bin);
use lib qw(/home/tickerlick/Tickermain);

my $docroot = $ENV{DOCUMENT_ROOT};
my $ID = "macd_535_5_bullish.csv";
my @fileholder;
my ($str) = '';
my ($filesloc) = "/home/tthaliath/perltest/bull/bull-535-2013-04-25.csv";

open(DLFILE,"<$filesloc");
@fileholder = <DLFILE>;
close(DLFILE);
#local $/ = 1;
my $size = -s $filesloc;
print "Content-Type:application/x-download\n";
print "Content-Length: $size\n"; 
print "Content-Disposition:attachment;filename=$ID\n\n";
print "$docroot\n";

