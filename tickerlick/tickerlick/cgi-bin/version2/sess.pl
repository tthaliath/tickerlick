#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath
#Program File: search.pl
#Date started : 06/24/03
#Last Modified : 11/07/03
#Purpose : Display the search result for the terms entered by user
use lib qw(/home/tickerlick/cgi-bin);
use lib qw(/home/tickerlick/Tickermain);
BEGIN { chdir('/home/tickerlick/cgi-bin'); }
BEGIN
{
push(@INC, '/usr/share/perl5/vendor_perl/CGI');
}
$| = 1;
use strict;
use warnings;
use CGI;
use TickerDB;
my ($q) = new CGI;
use CGI::Session;
my $cgi = new CGI;
my $session = CGI::Session->load($cgi) or die CGI::Session->errstr;
my $var = $session->param('name_of_user');
print "$var\n";

