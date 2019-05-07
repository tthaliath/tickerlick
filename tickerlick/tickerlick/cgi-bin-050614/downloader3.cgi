#!/usr/bin/perl

use CGI ':standard';
#use CGI::Carp qw(fatalsToBrowser); 

my $files_location; 
my $ID; 
my @fileholder;
my $docroot = $ENV{DOCUMENT_ROOT};

my $file = "$docroot/upload/bull-535-2013-04-25.csv";
$ID = "macd_535_5_bullish.csv";

if ($ID eq '') { 
print "Content-type: text/html\n\n"; 
print "You must specify a file to download."; 
} else {

open(DLFILE, "<$file")|| Error('open', $file); 
@fileholder = <DLFILE>; 
close (DLFILE) || Error ('close', 'file'); 


print "Content-Type:application/x-download\n"; 
print "Content-Disposition:attachment;filename=$ID\n\n";
print @fileholder;
}

sub Error {
      print "Content-type: text/html\n\n";
	print "HELLO, The server can't $_[0] the $_[1]: $! \n";
	exit;
}

